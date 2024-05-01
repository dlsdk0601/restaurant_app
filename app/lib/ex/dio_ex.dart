import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/common/secure_storage/secure_storage.dart';
import 'package:restaurant_app/restaurant/repository/restaurant_repository.dart';
import 'package:restaurant_app/user/repository/user_repository.dart';

final dioProvider = Provider((ref) {
  final dio = Dio(BaseOptions(baseUrl: ip));
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final String tokenEndpoint = "/auth/token";
  final String accessTokenKey = "accessToken";
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  String getBearerHeaderValue(String? token) {
    return "Bearer $token";
  }

  Map<String, String> getBearerHeader(String? token) {
    return {"authorization": getBearerHeaderValue(token)};
  }

  // 요청을 보낼 때
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers[accessTokenKey] == "true") {
      // 원래는 이런식으로 하지 않는다.
      // true 값 상관없이 token 이 있든 없든 일단 보내야하는게 맞다.
      options.headers.remove(accessTokenKey);
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll(getBearerHeader(token));
    }
    return super.onRequest(options, handler);
  }

  // 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답에 대해서는 따로 설정 할게 없어서 그냥 놔둔다.
    return super.onResponse(response, handler);
  }

  // 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 => 유효하지 않는 토큰
    // 토큰을 재발급 받는 시도를 하고 재발급 받으면 새 토큰으로 다시 요청
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 이 없다면 무조건 에러를 뱉어 낸다.
    if (refreshToken == null) {
      handler.reject(err);
      return;
    }

    // 401 에러 && 토큰 재발급 시도가 아닐때 (토큰 재발급인데도 401 이면 토큰이 잘못된거다)
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != tokenEndpoint) {
      try {
        final r = await getRefreshToken(err, handler, refreshToken);

        // err 를 뱉지 말고 다시 resolve 한다.
        return handler.resolve(r);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    return super.onError(err, handler);
  }

  Future<Response<dynamic>> getRefreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
    String refreshToken,
  ) async {
    // header 에 새로 셋팅해주기 위해 새로운 dio 로 인스턴스 빼준다.
    final dio = Dio();
    final userRepo = UserRepository(dio, baseUrl: ip);
    final res = await userRepo.getToken(
      token: getBearerHeaderValue(refreshToken),
    );

    final accessToken = res.accessToken;
    final options = err.requestOptions;
    options.headers.addAll(getBearerHeader(accessToken));
    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

    // 이미 options 안에 왠만한 정보가 다있어서, accessToken 만 바꾸고 다시 날린다.
    return dio.fetch(options);
  }
}

class DioBase {
  Codec<String, String> getCodec() {
    return utf8.fuse(base64);
  }

  String getBase64(String raw) {
    return getCodec().encode(raw);
  }

  String getBasicHeaderValue(String? token) {
    return "Basic $token";
  }

  Map<String, String> getBasicHeader(String? token) {
    return {"authorization": getBasicHeaderValue(token)};
  }
}

class DioEx extends DioBase {
  late final Dio dio;
  late final UserRepository userRepository;
  late final RestaurantRepository restaurantRepository;

  DioEx() {
    dio = Dio(BaseOptions(baseUrl: ip));
    // dio.interceptors.add(
    //   CustomInterceptor(storage: storage),
    // );
    userRepository = UserRepository(dio, baseUrl: ip);
    restaurantRepository = RestaurantRepository(dio, baseUrl: ip);
  }

  post({required String path, required Object? data}) async {
    return dio.post(path, data: data);
  }

  get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<SignInRes> signIn({
    required String userName,
    required String password,
  }) async {
    // login 의 경우 post 요청이 아닌 Basic 방식으로 하기에
    // 여기만 특별한 경우라서 따로 처리
    final token = getBase64("$userName:$password");
    return userRepository.signIn(token: getBasicHeaderValue(token));
  }

  Future<TokenRes> getAccessToken({required String refreshToken}) async {
    return userRepository.getToken(token: refreshToken);
  }

  Future<List<RestaurantListResItem>> getRestaurantList({
    required String after,
    required int count,
  }) async {
    final res = await restaurantRepository.paginate();
    return res.data;
  }

  Future<RestaurantShowRes> restaurantShow({required String id}) async {
    return restaurantRepository.getRestaurantDetail(id: id);
  }
}

final dioEx = DioEx();
