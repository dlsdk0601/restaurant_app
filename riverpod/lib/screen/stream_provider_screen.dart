import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/layout/default_layout.dart';
import 'package:riverpod_learn/riverpod/stream_provider.dart';

class StreamProviderScreen extends ConsumerWidget {
  const StreamProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // socker 에 어울리는 provider 로써 실시간으로 데이터가 업데이트 되면 리렌더링 한다.
    final state = ref.watch(multipleStreamProvider);

    return DefaultLayout(
      title: "StreamProviderScreen",
      body: Center(
        child: state.when(
          data: (data) => Text(
            data.toString(),
          ),
          error: (err, stack) => Text(
            err.toString(),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
