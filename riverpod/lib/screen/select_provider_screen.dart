import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/layout/default_layout.dart';
import 'package:riverpod_learn/riverpod/select_provider.dart';

class SelectProviderScreen extends ConsumerWidget {
  const SelectProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // state 를 한번에 다 불러오지 말고, 이렇게 특정 state 만 조회해서 들고 올  수 있다.
    final isSpicy = ref.watch(selectProvider.select((value) => value.isSpicy));
    final name = ref.watch(selectProvider.select((value) => value.name));

    // listen 에도 이렇게 가져올수 있다.
    // 여기서는 hasBought 값을 변경만 하지 조회하지 않기 때문에, build 는 재실행 되지 않지만,
    // 아래의 콜백 함수를 실행 된다.
    ref.listen(selectProvider.select((value) => value.hasBought),
        (previous, next) {
      print("next: $next");
    });

    return DefaultLayout(
        title: "SelectProviderScreen",
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
              ),
              Text(
                isSpicy.toString(),
              ),
              // Text(
              //   hasBought.toString(),
              // ),
              ElevatedButton(
                onPressed: () {
                  ref.read(selectProvider.notifier).toggleIsSpicy();
                },
                child: const Text("Spicy Toggle"),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(selectProvider.notifier).toggleHasBought();
                },
                child: const Text("hasBought Toggle"),
              ),
            ],
          ),
        ));
  }
}
