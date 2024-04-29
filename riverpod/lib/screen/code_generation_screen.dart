import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/layout/default_layout.dart';
import 'package:riverpod_learn/riverpod/code_generation_provider.dart';

class CodeGenerationScreen extends ConsumerWidget {
  const CodeGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // gState 는 관리할 state 를 return 하는 함수 일뿐 state 가 아니다.
    // generate 된 gStateProvider 를 가져온다
    final state1 = ref.watch(gStateProvider);
    final state2 = ref.watch(gStateFutureProvider);
    final state3 = ref.watch(gStateFuture2Provider);
    final state4 = ref.watch(gStateMultiplyProvider(num1: 10, num2: 20));
    final state5 = ref.watch(gStateNotifierProvider);

    return DefaultLayout(
      title: "CodeGenerationScreen",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("State1: $state1"),
          state2.when(
            data: (data) => Text(
              "state2: $data",
            ),
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          state3.when(
            data: (data) => Text(
              "state3: $data",
            ),
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Text("State4: $state4"),
          _StateFiveWidget(),
          // riverpod 에서 각각 state 마다 리렌더링을 막으려고 컴포넌트로 빼는건 불필요하니까
          // consumer 제공하는데, 불필요한 리렌더링을 막아준다.
          Consumer(
            builder: (context, ref, child) {
              final state5 = ref.watch(gStateNotifierProvider);
              return Column(
                children: [
                  Text("state5: $state5"),
                  if (child != null)
                    child, // react children 과 똑같다. 대신에 nullable 하다
                ],
              );
            },
            child: const Text("child"),
          ),
          // invalidate()
          // 유효하지 않게 하다
          ElevatedButton(
            onPressed: () {
              // 상태가 어떻게 변했든 초기값으로 돌아간다.
              // build 의 return 값으로 돌아간다는 말
              ref.invalidate(gStateNotifierProvider);
            },
            child: const Text("Invalidate"),
          )
        ],
      ),
    );
  }
}

// 이렇게 컴포넌트로 따로 빼야 불필요한 리렌더링을 하지 않는다.
class _StateFiveWidget extends ConsumerWidget {
  const _StateFiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state5 = ref.watch(gStateNotifierProvider);
    return Column(
      children: [
        Row(
          children: [
            Text("state5: $state5"),
            ElevatedButton(
              onPressed: () {
                ref.read(gStateNotifierProvider.notifier).increment();
              },
              child: const Text("Increment"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(gStateNotifierProvider.notifier).decrement();
              },
              child: const Text("Decrement"),
            ),
          ],
        ),
        // invalidate()
        // 유효하지 않게 하다
        ElevatedButton(
          onPressed: () {
            // 상태가 어떻게 변했든 초기값으로 돌아간다.
            // build 의 return 값으로 돌아간다는 말
            ref.invalidate(gStateNotifierProvider);
          },
          child: const Text("Invalidate"),
        )
      ],
    );
  }
}
