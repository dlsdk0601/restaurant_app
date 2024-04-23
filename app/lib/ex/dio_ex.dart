import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';

class DioEx {
  late final Dio dio;

  DioEx() {
    dio = Dio(BaseOptions(baseUrl: ip));
  }

  Codec<String, String> getCodec() {
    return utf8.fuse(base64);
  }

  String getBase64(String raw) {
    return getCodec().encode(raw);
  }

  String getBasicHeaderValue(String? token) {
    return "Basic $token";
  }

  String getBearerHeaderValue(String? token) {
    return "Bearer $token";
  }

  Map<String, String> getBasicHeader(String? token) {
    return {"authorization": getBasicHeaderValue(token)};
  }

  Map<String, String> getBearerHeader(String? token) {
    return {"authorization": getBearerHeaderValue(token)};
  }

  post({required String path, required String? token}) async {
    Options options = Options(
      headers: path.endsWith("login")
          ? getBasicHeader(token)
          : getBearerHeader(token),
    );

    return dio.post(path, options: options);
  }

  get({
    required String path,
    required Map<String, dynamic>? queryParameters,
  }) async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    return dio.get(
      path,
      options: Options(headers: {"authorization": "Bearer $accessToken"}),
      queryParameters: queryParameters,
    );
  }

  Future<SignInRes> signIn(
      {required String userName, required String password}) async {
    // id:password
    final raw = "$userName:$password";
    String token = getBase64(raw);

    final res = await post(
      path: "/auth/login",
      token: token,
    );

    final refreshToken = res.data["refreshToken"];
    final accessToken = res.data["accessToken"];
    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

    return SignInRes(
      refreshToken: res.data["refreshToken"],
      accessToken: res.data["accessToken"],
    );
  }

  Future<String?> getAccessToken({required String? refreshToken}) async {
    try {
      final res = await post(path: "/auth/token", token: refreshToken);

      return res.data["accessToken"];
    } catch (e) {
      return null;
    }
  }

  Future<List<RestaurantListResItem>> getRestaurantList({
    required String after,
    required int count,
  }) async {
    final res = await get(path: "/restaurant", queryParameters: {
      "after": after,
      "count": count,
    });

    final List<dynamic> data = res.data["data"];

    return data
        .map(
          (e) => RestaurantListResItem.fromJson(json: e),
        )
        .toList();
  }
}

final dioEx = DioEx();
