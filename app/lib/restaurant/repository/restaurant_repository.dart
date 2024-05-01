import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = RestaurantRepository(dio, baseUrl: ip);

  return repository;
});

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET("/restaurant")
  @Headers({
    "accessToken": "true",
  })
  Future<CursorPagination<RestaurantListResItem>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET("/restaurant/{id}")
  @Headers({
    "accessToken": "true",
  })
  Future<RestaurantShowRes> getRestaurantDetail({
    @Path() required String id,
  });
}
