import 'package:go_router/go_router.dart';
import 'package:gorouter/screens/root_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const RootScreen(),
    ),
  ],
);
