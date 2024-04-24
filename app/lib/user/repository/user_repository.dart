import 'package:dio/dio.dart' hide Headers;
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:retrofit/http.dart';

part 'user_repository.g.dart';

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET("/auth/login")
  Future<SignInRes> signIn({
    @Header("authorization") required String token,
  });

  @GET("/auth/token")
  Future<TokenRes> getToken({
    @Header("authorization") required String token,
  });
}
