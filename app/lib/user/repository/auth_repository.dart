import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/data_utils.dart';
import 'package:restaurant_app/ex/dio_ex.dart';

import '../../common/const/api_type.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: ip, dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<SignInRes> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.signInToken("$username:$password");

    final res = await dio.post(
      "$baseUrl/auth/login",
      options: Options(
        headers: DataUtils.getBasicHeader(serialized),
      ),
    );

    return SignInRes.fromJson(res.data);
  }

  Future<TokenRes> token() async {
    final res = await dio.post(
      "$baseUrl/auth/token",
      options: Options(
        headers: {
          // interceptor 에서 자동으로 바꿔주기에 이렇게 넣으면 된다.
          "refreshToken": "true",
        },
      ),
    );

    return TokenRes.fromJson(res.data);
  }
}
