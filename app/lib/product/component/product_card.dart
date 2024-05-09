import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/user/provider/basket_provider.dart';

class ProductCard extends ConsumerWidget {
  final String id;
  final Image image;
  final String name;
  final String detail;
  final int price;

  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    this.onRemove,
    this.onAdd,
  });

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onRemove,
    VoidCallback? onAdd,
  }) =>
      ProductCard(
        id: model.id,
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price,
        onAdd: onAdd,
        onRemove: onRemove,
      );

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantMenuItem model,
    VoidCallback? onRemove,
    VoidCallback? onAdd,
  }) =>
      ProductCard(
        id: model.id,
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price,
        onAdd: onAdd,
        onRemove: onRemove,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    // IntrinsicHeight
    // 내부 모든 위젯들이 최대 크기를 차지하는 widget 의 height 크기와 동일하게 적용
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      // TextOverflow.ellipsis
                      // ... 처리
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "₩$price",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (onRemove != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
              total: (basket
                          .firstWhere((element) => element.product.id == id)
                          .count *
                      basket
                          .firstWhere((element) => element.product.id == id)
                          .product
                          .price)
                  .toString(),
              count: basket
                  .firstWhere((element) => element.product.id == id)
                  .count,
              onRemove: onRemove!,
              onAdd: onAdd!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const _Footer({
    super.key,
    required this.total,
    required this.count,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "총액 $total",
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(icon: Icons.remove, onTap: onRemove),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            renderButton(icon: Icons.add, onTap: onAdd),
          ],
        )
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
