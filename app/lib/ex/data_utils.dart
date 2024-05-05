import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/common/provider/pagination_provider.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return "${ip}${value}";
  }

  // parameter 가 List<String> 으로 하지 않은 이유는 API 에서 받을때는 List<dynamic> 으로 인식하기 때문에
  // 타입 에러가 난다.
  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static void paginateInit({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    // 현재 위치가 최대 길이 보다 덜 되는 위치 까지 왔다면
    // 다음 페이지 fetch

    // controller.offset => 현재 스크롤
    // controller.position.maxScrollExtent => 스크롤 할 수 있는 최대 스크롤
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
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
