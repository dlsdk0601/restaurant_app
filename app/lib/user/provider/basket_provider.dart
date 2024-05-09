import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';

import '../repository/user_repository.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return BasketProvider(repository: repository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1. 장바구니에 없는 item 추가 => count 1 로 추가
    // 2. 장바구니에 있는 item 추가 => count++

    final item = getItemById(product.id);
    final origin = state;

    // 존재 x
    if (item == null) {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    } else {
      // 존재 할 때 (count + 1)
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    }

    // 여기서 요청을 보낸다.
    // UI 상 state 를 먼저 업데이트 시키는게 인터페이스가 좋다.
    // Optimistic Response (긍정적 응답) => 응답이 성공할 거라고 가정하고 상태를 먼저 업데이트 => 대신 실패하면 원복해야함
    try {
      await patchBasket();
    } catch (e) {
      state = origin;
    }
  }

  Future<void> removeFromBasket(
      {required ProductModel product, bool isDelete = false}) async {
    // 존재 할때 안할때 구분 해야 한다.
    // 존재 할때 => count - 1 or count ==1 => 삭제

    final item = getItemById(product.id);
    final origin = state;

    // 없다
    if (item == null) {
      return;
    }

    // count = 1 일 때
    // isDelete => 해당 item 을 count 상관 없이 삭제
    if (item.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      // count - 1
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }

    try {
      await patchBasket();
    } catch (e) {
      // API 실패 시 원복
      state = origin;
    }
  }

  BasketItemModel? getItemById(String id) {
    return state.firstWhereOrNull((element) => element.product.id == id);
  }
}
