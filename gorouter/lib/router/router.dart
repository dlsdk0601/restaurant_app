import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/screens/10_transition_screen_1.dart';
import 'package:gorouter/screens/11_error_screen.dart';
import 'package:gorouter/screens/1_basic_screen.dart';
import 'package:gorouter/screens/2_named_screen.dart';
import 'package:gorouter/screens/3_push_screen.dart';
import 'package:gorouter/screens/4_pop_base_screen.dart';
import 'package:gorouter/screens/5_pop_return_screen.dart';
import 'package:gorouter/screens/6_path_param_screen.dart';
import 'package:gorouter/screens/7_query_parameter_screen.dart';
import 'package:gorouter/screens/8_nested_child_screen.dart';
import 'package:gorouter/screens/8_nested_screen.dart';
import 'package:gorouter/screens/9_login_screen.dart';
import 'package:gorouter/screens/9_private_screen.dart';
import 'package:gorouter/screens/root_screen.dart';

import '../screens/10_transition_screen_2.dart';

// 로그인 여부
bool authState = false;

final router = GoRouter(
  // 전역 으로 적용, 어디로든 route 이동 할 때 마다 실행
  redirect: (context, state) {
    // return String => String 에 해당하는 path route 로 이동
    // return null => 원래 이동하려던 route 로 이
    if (state.uri.path == "/login/private" && !authState) {
      return "/login";
    }

    return null;
  },
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const RootScreen(),
      routes: [
        GoRoute(
          path: "basic",
          builder: (context, state) => const BasicScreen(),
        ),
        GoRoute(
          path: "named",
          name: "named_screen",
          builder: (context, state) => const NamedScreen(),
        ),
        GoRoute(
          path: "push",
          builder: (context, state) => const PushScreen(),
        ),
        GoRoute(
          // /pop
          path: "pop",
          builder: (context, state) => const PopBaseScreen(),
          routes: [
            GoRoute(
              // /pop/return
              path: "return",
              builder: (context, state) => const PopReturnScreen(),
            ),
          ],
        ),
        GoRoute(
          path: "path_param/:id",
          builder: (context, state) => const PathParamScreen(),
          routes: [
            GoRoute(
              path: ":name",
              builder: (context, state) => const PathParamScreen(),
            ),
          ],
        ),
        GoRoute(
          path: "query_param",
          builder: (context, state) => const QueryParameterScreen(),
        ),
        ShellRoute(
          // child => react 의 children 과 비슷
          builder: (context, state, child) => NestedScreen(child: child),
          routes: [
            GoRoute(
              // /nested/a
              path: "nested/a",
              builder: (context, state) =>
                  const NestedChildScreen(routerName: "/nested/a"),
            ),
            GoRoute(
              // /nested/b
              path: "nested/b",
              builder: (context, state) =>
                  const NestedChildScreen(routerName: "/nested/b"),
            ),
            GoRoute(
              // /nested/c
              path: "nested/c",
              builder: (context, state) =>
                  const NestedChildScreen(routerName: "/nested/c"),
            ),
          ],
        ),
        GoRoute(
          path: "login",
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              path: "private",
              builder: (context, state) => const PrivateScreen(),
            ),
          ],
        ),
        GoRoute(
          path: "login2",
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
                path: "private",
                builder: (context, state) => const PrivateScreen(),
                // 지역 route, /login2/private 로 이동 할때만 실행 되는 콜백
                redirect: (context, state) {
                  if (!authState) {
                    return "/login2";
                  }

                  return null;
                }),
          ],
        ),
        GoRoute(
            path: "transition",
            builder: (context, state) => const TransitionScreenOne(),
            routes: [
              GoRoute(
                path: "detail",
                pageBuilder: (_, state) => CustomTransitionPage(
                  // trasition 시간
                  transitionDuration: const Duration(seconds: 3),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // animation => 0 -> 1 까지 점점 밝아짐
                    // secondaryAnimation => animation 의 반대로
                    // ScaleTransition => scale 에 transition 걸린다.
                    // FadeTransition => fade in out 효과
                    // RorationTransition => 회전 효과
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: const TransitionScreenTwo(),
                ),
              ),
            ])
      ],
    ),
  ],
  // 특별히 다른 에러는 아니고 go_router 에서 에러가 발생 시, 이동되는 에러 페이지
  errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
  // route 에 대한 log 활성화
  debugLogDiagnostics: true,
);
