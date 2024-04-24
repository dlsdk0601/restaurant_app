import 'package:dio/dio.dart' hide Headers;
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // @GET("/")
  // paginate();

  @GET("/restaurant/{id}")
  @Headers({
    "accessToken": "true",
  })
  Future<RestaurantShowRes> getRestaurantDetail({
    @Path() required String id,
  });
}
