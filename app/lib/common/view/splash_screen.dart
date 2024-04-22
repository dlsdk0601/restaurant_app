import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';
import 'package:restaurant_app/common/view/root_tab.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:restaurant_app/user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final res = await dioEx.getAccessToken(refreshToken: refreshToken);

    // error 났을때
    if (res == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      return;
    }

    // token 이 정상적으로 왔을때
    await storage.write(key: ACCESS_TOKEN_KEY, value: res);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootTab()),
      (route) => false,
    );
  }

  Future<void> deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "asset/img/logo/logo.png",
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
