import 'package:flutter_riverpod/flutter_riverpod.dart';

final multiplesFutureProvider = FutureProvider<List<int>>((ref) async {
  await Future.delayed(
    Duration(seconds: 3),
  );

  // throw Exception("에러남");

  return [1, 2, 3, 4];
});
