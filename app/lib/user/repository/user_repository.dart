import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:retrofit/http.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = UserRepository(dio, baseUrl: ip);

  return repository;
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @POST("/auth/login")
  Future<SignInRes> signIn({
    @Header("authorization") required String token,
  });

  @POST("/auth/token")
  Future<TokenRes> getToken({
    @Header("authorization") required String token,
  });
}
