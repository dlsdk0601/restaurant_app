import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';
import 'package:restaurant_app/ex/data_utils.dart';
import 'package:restaurant_app/product/component/product_card.dart';
import 'package:restaurant_app/rating/component/rating_card.dart';
import 'package:restaurant_app/rating/provider/restaurant_rating_provider.dart';
import 'package:restaurant_app/restaurant/component/restaurant_card.dart';
import 'package:restaurant_app/restaurant/provider/restaurant_provider.dart';
import 'package:restaurant_app/restaurant/view/basket_Screen.dart';
import 'package:restaurant_app/user/provider/basket_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routerName => "restaurantDetail";
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
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  void listener() {
    DataUtils.paginateInit(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: "불타는 떡볶",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routerName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold(0, (prev, next) => prev + next.count).toString(),
            style: const TextStyle(color: PRIMARY_COLOR, fontSize: 10.0),
          ),
          badgeStyle: const BadgeStyle(badgeColor: Colors.white),
          child: const Icon(Icons.shopping_basket_outlined),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantShowRes) renderLoading(),
          if (state is RestaurantShowRes) renderLabel(),
          if (state is RestaurantShowRes)
            renderProducts(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(
              models: ratingsState.data,
            )
        ],
      ),
    );
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: models.length,
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
        ),
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

  SliverPadding renderProducts({
    required List<RestaurantMenuItem> products,
    required RestaurantListResItem restaurant,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            // GestureDetector 는 onTap 이 동작 하지만 애니메이션이 없다.
            // InkWell 은 tap 할 경우 애니메이션 효과가 있음.
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        imgUrl: model.imgUrl,
                        price: model.price,
                        restaurant: restaurant,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
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
