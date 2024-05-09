import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';

class BasketScreen extends ConsumerWidget {
  static String get routerName => "basket";

  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: "장바구니",
      child: Column(),
    );
  }
}