import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/layout/default_layout.dart';

import '../riverpod/auto_dispose_modifier_provider.dart';

class AutoDisposeModifierScreen extends ConsumerWidget {
  const AutoDisposeModifierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 대부분 상태관리 provider 는 모두 캐싱 되서 처음만 로딩하는데,
    // autoDispose 는 자동으로 삭제 한다는 뜻이므로, 매번 새롭게 값을 만든다.
    final state = ref.watch(autoDisposeModifierProvider);

    return DefaultLayout(
      title: "AutoDisposeModifierScreen",
      body: Center(
        child: state.when(
          data: (data) => Text(data.toString()),
          error: (err, stack) => Text(err.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
