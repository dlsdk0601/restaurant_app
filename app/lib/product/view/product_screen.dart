import 'package:flutter/material.dart';
import 'package:restaurant_app/common/component/pagination_list_view.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/product/component/product_card.dart';
import 'package:restaurant_app/product/provider/product_provider.dart';
import 'package:restaurant_app/restaurant/view/restaurant_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(id: model.restaurant.id),
              ),
            );
          },
          child: ProductCard.fromProductModel(model: model),
        );
      },
    );
  }
}
