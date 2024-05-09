import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/user/provider/basket_provider.dart';
import 'package:uuid/uuid.dart';

import '../repository/order_repository.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  return OrderStateNotifier(
    ref: ref,
    repository: ref.watch(orderRepositoryProvider),
  );
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);

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
