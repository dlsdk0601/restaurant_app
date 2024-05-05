import 'package:dio/dio.dart' hide Headers;
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:retrofit/http.dart';

part 'rating_repository.g.dart';

@RestApi()
abstract class RestaurantRatingRepository {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET("/restaurant")
  @Headers({
    "accessToken": "true",
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
