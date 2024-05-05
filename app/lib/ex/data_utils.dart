import 'dart:convert';

import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return "${ip}${value}";
  }

  static List<String> listPathsToUrls(List<String> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static Future<void> setTokenStorage(SignInRes res) async {
    final refreshToken = res.refreshToken;
    final accessToken = res.accessToken;
    // await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
    // await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
  }

  static Codec<String, String> getCodec() {
    return utf8.fuse(base64);
  }

  static String getBase64(String raw) {
    return getCodec().encode(raw);
  }

  static String signInToken(String raw) {
    final token = getBase64(raw);
    return "Basic $token";
  }

  static String authorizationToken(String raw) {
    final token = getBase64(raw);
    return getBearerHeaderValue(token);
  }

  static String getBearerHeaderValue(String? token) {
    return "Bearer $token";
  }

  static Map<String, String> getBearerHeader(String? token) {
    return {"authorization": getBearerHeaderValue(token)};
  }
}
