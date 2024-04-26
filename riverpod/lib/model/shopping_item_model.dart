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
}
