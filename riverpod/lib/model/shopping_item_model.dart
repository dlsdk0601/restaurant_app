import 'package:flutter/material.dart';

class ShoppingItemModel {
  final String name; // 이름
  final int quantity; // 수량
  final bool hasBought; // 구매 했는지
  final bool isSpicy; // 매운지

  ShoppingItemModel({
    required this.name,
    required this.quantity,
    required this.hasBought,
    required this.isSpicy,
  });

  ShoppingItemModel copyWith({
    String? name,
    int? quantity,
    bool? hasBought,
    bool? isSpicy,
  }) {
    final ts = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );

    // 이런 방법을 통해서 state 의 불변성을 유지한다.
    final ts2 = ts.copyWith(fontSize: 18.0);

    return ShoppingItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      hasBought: hasBought ?? this.hasBought,
      isSpicy: isSpicy ?? this.isSpicy,
    );
  }
}
