import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/layout/default_layout.dart';
import 'package:riverpod_learn/riverpod/state_provider_screen.dart';

// ConsumerWidget => react contextAPI 에서 consumer 에 해당 하는 역할
// stless 와 매우 흡사해서 똑같이 쓰면 되지만, build 함수에서 WidgetRef 파라미터 하나를 더 받는다.
class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref 에는 watch 와 read 가 있는데,

    final provider = ref.watch(numberProvider);

    return DefaultLayout(
      title: "StateProviderScreen",
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.toString()),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
              child: const Text("UP"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _NextScreen(),
                  ),
                );
              },
              child: const Text("Next Screen"),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextScreen extends ConsumerWidget {
  const _NextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvider);
    return DefaultLayout(
      title: "StateProviderScreen",
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.toString()),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
              child: const Text("UP"),
            ),
          ],
        ),
      ),
    );
  }
}
