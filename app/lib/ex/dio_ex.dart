import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/config.dart';

class DioEx {
  late final Dio dio;

  DioEx() {
    final ip = Platform.isIOS ? config.simulatorIp : config.emulatorIp;
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
}

final dioEx = DioEx();
