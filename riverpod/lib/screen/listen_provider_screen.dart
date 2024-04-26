import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/layout/default_layout.dart';

import '../riverpod/listen_provider.dart';

class ListenProviderScreen extends ConsumerStatefulWidget {
  const ListenProviderScreen({super.key});

  @override
  ConsumerState<ListenProviderScreen> createState() =>
      _ListenProviderScreenState();
}

class _ListenProviderScreenState extends ConsumerState<ListenProviderScreen>
    with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 10,
      vsync: this,
      // tabcontroller 의 init 의 default 가 0 이라서 뒤로 갔다 다시 오면 0 부터 시작한다.
      // listenProvider 의 값으로 init 하고 싶다면 ref 의 값을 불러 오면 된다.
      initialIndex: ref.read(listenProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    // listen provider 는 ref 를 받지 않는다.
    // riverpod 이 자동으로 dispose 하기 때문에 중복으로 listen 하지 않는다. 그래서 dispose 할 필요 없다
    ref.listen<int>(listenProvider, (previous, next) {
      // previous => 이전 상태
      // next => 바꾸고 싶은 상태 값
      if (previous != next) {
        controller.animateTo(next);
      }
    });

    return DefaultLayout(
      title: "ListenProviderScreen",
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: List.generate(
          10,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                index.toString(),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(listenProvider.notifier)
                      .update((state) => state == 10 ? 10 : state + 1);
                },
                child: const Text("NEXT"),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(listenProvider.notifier)
                      .update((state) => state == 0 ? 0 : state - 1);
                },
                child: const Text("PREV"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
