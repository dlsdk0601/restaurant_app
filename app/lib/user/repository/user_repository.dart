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

  @GET("/user/me")
  @Headers({
    "accessToken": "true",
  })
  Future<UserModel> getMe();

  @GET("/user/me/basket")
  @Headers({"accessToken": "true"})
  Future<List<BasketItemModel>> getBasket();

  @PATCH("/user/me/basket")
  @Headers({"accessToken": "true"})
  Future<List<BasketItemModel>> patchBasket({
    @Body() required PatchBasketBody body,
  });
}
