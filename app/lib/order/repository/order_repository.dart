import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:retrofit/http.dart';

import '../../common/const/api_type.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return OrderRepository(dio, baseUrl: ip);
});

@RestApi()
abstract class OrderRepository {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @POST("/order")
  @Headers({"accessToken": "true"})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
