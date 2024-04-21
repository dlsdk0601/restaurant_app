import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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

  post({required String path, Options? options}) async {
    return dio.post(path, options: options);
  }

  signIn(String userName, String password) async {
    // id:password
    final raw = "$userName:$password";
    String token = getBase64(raw);

    final res = await post(
      path: "/auth/login",
      options: Options(
        headers: {
          "authorization": "Basic $token",
        },
      ),
    );

    print("res.data");
    print(res.data);
  }
}

final dioEx = DioEx();
