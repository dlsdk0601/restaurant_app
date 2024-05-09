import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/view/root_tab.dart';
import 'package:restaurant_app/common/view/splash_screen.dart';
import 'package:restaurant_app/restaurant/view/basket_screen.dart';
import 'package:restaurant_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:restaurant_app/user/provider/user_provider.dart';
import 'package:restaurant_app/user/view/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: "/",
          name: RootTab.routerName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: "restaurant/:rid",
              name: RestaurantDetailScreen.routerName,
              builder: (_, state) => RestaurantDetailScreen(
                id: state.pathParameters["rid"]!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: "/basket",
          name: BasketScreen.routerName,
          builder: (_, state) => const BasketScreen(),
        ),
        GoRoute(
          path: "/splash",
          name: SplashScreen.routerName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: "/login",
          name: LoginScreen.routerName,
          builder: (_, __) => const LoginScreen(),
        )
      ];

  // splashScreen
  // 앱 처음 시작 할때
  // 토근 존재 확인 => 로그인 스크린 or 홈 스크린
  FutureOr<String?> redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userProvider);
    final isLoginPath = state.uri.path == "/login";

    // 유저 정보가 없는데 로그인중이면 그대로
    // 로그인 중 아니면 로그인 페이지로 이동
    if (user == null) {
      return isLoginPath ? null : "/login";
    }

    // user 가 null 이 아님

    // 1. UserModel
    // 사용자 정보 있는데 로그인중이거나 splashScreen 이면 홈으로 이동
    if (user is UserModel) {
      return isLoginPath || state.uri.path == "/splash" ? "/" : null;
    }

    // 2. UserModelError
    // 로그인 페이지 아니면 로그인 페이지로, 아니면 원하는 대로
    if (user is UserModelError) {
      return !isLoginPath ? "/login" : null;
    }

    // 나머지는 원래 가던대로 가라
    return null;
  }

  logout() {
    ref.read(userProvider.notifier).logout();
  }
}
