import 'package:go_router/go_router.dart';
import 'package:gorouter/screens/1_basic_screen.dart';
import 'package:gorouter/screens/2_named_screen.dart';
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
      ],
    ),
  ],
);
