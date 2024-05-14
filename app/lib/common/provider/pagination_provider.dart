import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/repository/base_pagination_repository.dart';

class _PaginationInfo {
  final int fetchCount;

  // true - 추가로 데이터 가져옴
  // false - 새로고침 (현재 상태를 덮어씌움)
  final bool fetchMore;

  // 강제 로딩
  // true - CursorPaginationLoading()
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final throttle = Throttle(
    const Duration(seconds: 1),
    initialValue: _PaginationInfo(),
    checkEquality: false, // 실행 함수가 똑같으면 넣지 않는다는 옵션인데, false 로 해서 실행하게 한다.
  );

  PaginationProvider({
    required this.repository,
  }) : super(
          CursorPaginationLoading(),
        ) {
    paginate();
    throttle.values.listen((state) {
      // setValue 에서 받아온 값이 state 로 넘어온다.
      // 처음에는 initialValue 가 들어온다.
      _throttledPagination(state);
    });
  }

  Future<void> paginate({
    int fetchCount = 20,
    // true - 추가로 데이터 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제 로딩
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    throttle.setValue(_PaginationInfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  _throttledPagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;
    try {
      /*
    * 5가지 경우의 수
    * 1) CursorPagination - 정상적으로 데이터가 있는 상태
    * 2) CursorPaginationLoading - 데이터가 로딩중 (현재 캐시 없음(
    * 3) CursorPaginationError - 에러 상태
    * 4) CursorPaginationRefetching - 첫번쨰 페이지부터 다시 패치
    * 5) CursorPaginationFetchMore - 다음 page 요청
    *
    * */

      // 바로 반환 하는 상황
      // 1) hasMore = false (다음 페이지 존재 x)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      // 2) 로딩 중 && fetchMore 일 경우
      // 첫 로딩
      final isLoading = state is CursorPaginationLoading;
      // 첫 로딩 후 새로고침
      final isRefetching = state is CursorPaginationRefetching;
      // 다음 페이지 패치 로딩중
      final isFetchingMore = state is CursorPaginationFetchingMore;
      // 세가지 로딩 중 하나라도 로딩 중일때
      final loading = isLoading || isRefetching || isFetchingMore;
      if (fetchMore && loading) {
        return;
      }

      PaginationParams paginationParams = const PaginationParams(
        count: 20,
      );

      // fetchMore => 다음 페이지 패치
      if (fetchMore) {
        // fetchMore 가 true 이면 상태는 CursorPagination 이여야 한다.
        final pState = state as CursorPagination<T>;

        // 현재 fetch 상황이라서 state 의 상태 클래스를 CursorPaginationFetchingMore 로 해준다.
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        // 마지막 id after 에 추가
        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        // 다음 페이지 로딩이 아닌 상황

        // 만약에 데이터가 있는 상황 => 기존 데이터를 보존한채로 fetch 진행
        if (state is CursorPagination && !forceRefetch) {
          // 데이터가 있는데 로딩중
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // 나머지 상황
          // 데이터 없거나, forceRefetch 이면 로딩중 (첫 로딩이거나, 강제 재시작임)
          state = CursorPaginationLoading();
        }
      }

      final res = await repository.paginate(paginationParams: paginationParams);

      // 다음 페이지 패치 해왓을 경우
      if (state is CursorPaginationFetchingMore) {
        // 이 작업을 왜하냐면 일단 상태 클래스도 바꿔줘야하지만,
        // 현재 해당 어플 기획은 무한 스크롤이기 때문에
        // 기존 리스트 + 새로 받아온 리스트 이렇게 붙여줘야 한다.

        // 기존 state
        final pState = state as CursorPaginationFetchingMore;

        // 기존 state + 새 state
        state = res.copyWith(
          data: [...pState.data, ...res.data],
        );
        return;
      } else {
        // 맨 처음 or 강제 재시작이라서 res 를 그대로 담는다.
        state = res;
      }

      state = res;
    } catch (e) {
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다.");
    }
  }
}
