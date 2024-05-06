import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/common/repository/base_pagination_repository.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:retrofit/http.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return ProductRepository(dio, baseUrl: ip);
});

@RestApi()
abstract class ProductRepository
    implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @override
  @GET("/product")
  @Headers({
    "accessToken": "true",
  })
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
