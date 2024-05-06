import 'package:collection/collection.dart';
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

  // firstWhere 의 단점은 존재하지 않으면 null 이 아닌 error 를 던진다.
  // 그래서 collection 에서 orNull 로 수정 해준다.
  return state.data.firstWhereOrNull((element) => element.id == id);
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

    /*
    * 경우의 수를 잘 생각 해보자
    * 1. [ListModel(1), ListModel(2), ListModel(3)]
    * id 가 2 라면 getDetail 로 2 가져옴
    * id 가 2인 ListModel(2) 를 DetailModel(2) 로 대치
    *
    * 2. 근데 [ListModel(1), ListModel(2), ListModel(3)] 인데,
    * id 가 5라면, 에러가 난다.
    * 이럴때는 list 끝에다가 데이터를 추가
    * [ListModel(1), ListModel(2), ListModel(3), DetailModel(5)]
    * */

    if (pState.data.where((element) => element.id == id).isEmpty) {
      // list 에 데이터가 존재하지 않을
      state = pState.copyWith(
        data: <RestaurantListResItem>[...pState.data, res],
      );
    } else {
      // list 에 데이터가 이미 존재 할 때
      // id 인 데이터는 새로 받은 res 로 그외에는 기존 데이터 e 로
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantListResItem>((e) => e.id == id ? res : e)
            .toList(),
      );
    }
  }
}
