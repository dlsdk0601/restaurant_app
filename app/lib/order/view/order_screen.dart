import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/component/pagination_list_view.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/order/provider/order_provider.dart';

import '../component/order_card.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
