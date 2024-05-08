import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/user/provider/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // go router 는 한번만 읽으면 됨.
  final provider = ref.read(authProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: "/splash",
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
