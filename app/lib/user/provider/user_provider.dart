import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/common/secure_storage/secure_storage.dart';
import 'package:restaurant_app/user/repository/auth_repository.dart';

import '../../common/const/api_type.dart';
import '../repository/user_repository.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserNotifier(
    authRepository: authRepository,
    repository: userRepository,
    storage: storage,
  );
});

class UserNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserRepository repository;
  final FlutterSecureStorage storage;

  UserNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기;
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final res = await repository.getMe();

    state = res;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final res = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: res.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: res.accessToken);

      // 토큰 발급 받았으니 유저 정보 조회
      final userRes = await repository.getMe();

      state = userRes;

      return userRes;
    } catch (e) {
      state = UserModelError(message: "로그인에 실패했습니다.");

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    // await 붙이면 모두 끝날 때까지 기다림.
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
