import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/restaurant/repository/restaurant_repository.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantListResItem>>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier
    extends StateNotifier<List<RestaurantListResItem>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    // 해당 provider 가 생성 될때 바로 paginate 를 실행시켜주기 위해서 한번 호출 한다.
    paginate();
  }

  paginate() async {
    final res = await repository.paginate(after: "", count: 20);

    state = res.data;
  }
}
