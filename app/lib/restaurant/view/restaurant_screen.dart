import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/common/component/pagination_list_view.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/restaurant/component/restaurant_card.dart';
import 'package:restaurant_app/restaurant/provider/restaurant_provider.dart';
import 'package:restaurant_app/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantListResItem>(
        provider: restaurantProvider,
        itemBuilder: <RestaurantListResItem>(_, index, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                RestaurantDetailScreen.routerName,
                pathParameters: {
                  "rid": model.id,
                },
              );
            },
            child: RestaurantCard.fromModel(
              model: model,
            ),
          );
        });
  }
}
