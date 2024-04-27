import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider observer 로 logging 하는 방법
class Logger extends ProviderObserver {
  // provider 업데이트 될때 마다 호출되는 함수
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print(
      "[Provider updated] provider: $provider / pv: $previousValue / nv: $newValue",
    );
  }

  // provider 추가 될때 마다 호출 되는 함수
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    print(
      "[Provider Added] provider: $provider / value: $value",
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    print(
      "[Provider Disposed] provider: $provider",
    );
  }
}
