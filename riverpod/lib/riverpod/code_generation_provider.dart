import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_generation_provider.g.dart';

/*
* code generation 을 사용하는 이유
*
* 1) 어떤 provider 를 사용할지 고민 x
* Provider, FutureProvider 등등
*
* 2) Parameter > Family 파라미터를 이반 함수처럼 사용가능하게
*
* */

// 1) 번 예제
// 원래 state 작성법
// final _testProvider = Provider<String>((ref) => "Hello World");

@riverpod
String gState(GStateRef ref) {
  // 파라미터를 해당 함수의 이름과 동일하지만 파스칼 케이스로 작성해야한다.
  return "Hello World";
}

@riverpod
Future<int> gStateFuture(GStateFutureRef ref) async {
  await Future.delayed(const Duration(seconds: 3));

  return 10;
}

// * 단순하게 @riverpod 어노테이션을 사용하면, default 로 autoDisposeProvider 를 사용한다.
// 캐싱에 저장되지 않아서 상황에 따라 다르게 사용해야할수도 있음

// autoDispose 를 사용하고 싶지 않을때
@Riverpod(
  // 살려놔다
  keepAlive: true,
)
Future<int> gStateFuture2(GStateFuture2Ref ref) async {
  await Future.delayed(const Duration(seconds: 3));

  return 10;
}

// 2) 예제
// 기존에 family 사용법
// class P {
//   final int num1;
//   final int num2;
//
//   P({
//     required this.num1,
//     required this.num2,
//   });
// }
//
// final _testFamilyProvider = Provider.family<int, P>(
//   (ref, p) => p.num1 * p.num1,
// );

@riverpod
int gStateMultiply(
  GStateMultiplyRef ref, {
  required int num1,
  required int num2,
}) {
  return num1 * num2;
}

// stateNotifier
@riverpod
class GStateNotifier extends _$GStateNotifier {
  @override
  int build() {
    return 0;
  }

  increment() {
    state++;
  }

  decrement() {
    state--;
  }
}
