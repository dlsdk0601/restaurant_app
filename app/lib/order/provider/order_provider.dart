import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/provider/pagination_provider.dart';
import 'package:restaurant_app/user/provider/basket_provider.dart';
import 'package:uuid/uuid.dart';

import '../repository/order_repository.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  return OrderStateNotifier(
    ref: ref,
    repository: ref.watch(orderRepositoryProvider),
  );
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final id = uuid.v4();

      final basket = ref.read(basketProvider);

      final res = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basket
              .map(
                (e) => PostOrderBodyProduct(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: basket.fold(
              0, (prev, next) => prev + (next.product.price * next.count)),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
