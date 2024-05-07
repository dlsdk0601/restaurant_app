import 'package:go_router/go_router.dart';
import 'package:gorouter/screens/1_basic_screen.dart';
import 'package:gorouter/screens/2_named_screen.dart';
import 'package:gorouter/screens/3_push_screen.dart';
import 'package:gorouter/screens/4_pop_base_screen.dart';
import 'package:gorouter/screens/5_pop_return_screen.dart';
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
      ],
    ),
  ],
);
