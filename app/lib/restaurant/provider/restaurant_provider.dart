import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/provider/pagination_provider.dart';
import 'package:restaurant_app/restaurant/repository/restaurant_repository.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantListResItem?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    // CursorPagination 이게 아니라면 restaurantProvider 가 없다는 말이다.
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantListResItem, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  getDetail({
    required String id,
  }) async {
    // 아직 데이터가 하나도 없다면, 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state 가 CursorPagination 이 아닐때 그냥 return
    // 바로 위에서 paginate() 를 했음에도 state 가 CursorPagination 이 아니라면 이건 에러다.
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final res = await repository.getRestaurantDetail(id: id);

    // id 인 데이터는 새로 받은 res 로 그외에는 기존 데이터 e 로
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantListResItem>((e) => e.id == id ? res : e)
          .toList(),
    );
  }
}
