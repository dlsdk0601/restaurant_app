import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/model/shopping_item_model.dart';
import 'package:riverpod_learn/riverpod/state_notifier_provider.dart';

// shoppingListProvider 를 provider 로 관리
// shoppingListProvider 이게 변경된다면 filteredShoppingListProvider 를 구독하는 모든 위젯에서
// re render 가 된다.
final filteredShoppingListProvider = Provider<List<ShoppingItemModel>>(
  (ref) {
    final filterState = ref.watch(filterProvider);
    final shoppingListState = ref.watch(shoppingListProvider);
    if (filterState == FilterState.all) {
      return shoppingListState;
    }

    return shoppingListState
        .where((element) => filterState == FilterState.spicy
            ? element.isSpicy
            : !element.isSpicy)
        .toList();
  },
);

enum FilterState {
  // 안매움
  notSpicy,
  // 매움
  spicy,
  // 둘다
  all
}

final filterProvider = StateProvider((ref) => FilterState.all);
