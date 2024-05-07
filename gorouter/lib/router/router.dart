import 'package:go_router/go_router.dart';
import 'package:gorouter/screens/1_basic_screen.dart';
import 'package:gorouter/screens/2_named_screen.dart';
import 'package:gorouter/screens/3_push_screen.dart';
import 'package:gorouter/screens/4_pop_base_screen.dart';
import 'package:gorouter/screens/5_pop_return_screen.dart';
import 'package:gorouter/screens/6_path_param_screen.dart';
import 'package:gorouter/screens/7_query_parameter_screen.dart';
import 'package:gorouter/screens/8_nested_child_screen.dart';
import 'package:gorouter/screens/8_nested_screen.dart';
import 'package:gorouter/screens/root_screen.dart';

final router = GoRouter(
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
      ],
    ),
  ],
);
