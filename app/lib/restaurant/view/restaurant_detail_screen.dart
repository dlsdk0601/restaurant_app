import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';
import 'package:restaurant_app/product/component/product_card.dart';
import 'package:restaurant_app/rating/component/rating_card.dart';
import 'package:restaurant_app/restaurant/component/restaurant_card.dart';
import 'package:restaurant_app/restaurant/provider/restaurant_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: "불타는 떡볶",
      child: CustomScrollView(
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantShowRes) renderLoading(),
          if (state is RestaurantShowRes) renderLabel(),
          if (state is RestaurantShowRes)
            renderProducts(products: state.products),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: RatingCard(
                rating: 4,
                email: "test@test.com",
                images: [],
                avatarImage: AssetImage("asset/img/logo/codefactory_logo.png"),
                content:
                    "굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳굳",
              ),
            ),
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantListResItem model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts({required List<RestaurantMenuItem> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          "메뉴",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
