import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_app/ex/data_utils.dart';

part 'api_type.g.dart';

// pagination 기본 class
abstract class CursorPaginationBase {}

// pagination err 상태 class
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// pagination loading 상태 class
class CursorPaginationLoading extends CursorPaginationBase {}

// pagination 성공 상태 class
@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({required this.meta, required this.data});

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({int? count, bool? hasMore}) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// pagination 새로 고침 위한 class
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 무한 스크롤 다음 페이지 faetching 을 위한 클래스
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}

@JsonSerializable()
class PaginationParams {
  final String? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });

  PaginationParams copyWith({
    String? after,
    int? count,
  }) {
    return PaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}

@JsonSerializable()
class SignInRes {
  final String refreshToken;
  final String accessToken;

  SignInRes({required this.refreshToken, required this.accessToken});

  factory SignInRes.fromJson(Map<String, dynamic> json) =>
      _$SignInResFromJson(json);
}

@JsonSerializable()
class TokenRes {
  final String accessToken;

  TokenRes({required this.accessToken});

  factory TokenRes.fromJson(Map<String, dynamic> json) =>
      _$TokenResFromJson(json);
}

enum RestaurantPriceRange { cheap, medium, expensive }

@JsonSerializable()
class RestaurantListResItem implements IModelWithId {
  final String id; // "1952a209-7c26-4f50-bc65-086f6e64dbbd",
  final String name; // "우라나라에서 가장 맛있는 짜장면집",
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl; // "/img/thumb.png",
  final List<String> tags; // ["신규","세일중"],
  final RestaurantPriceRange priceRange; // "cheap",
  final double ratings; // 4.89,
  final int ratingsCount; // 200,
  final int deliveryTime; // 20,
  final int deliveryFee; // 3000

  RestaurantListResItem({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantListResItem.fromJson(Map<String, dynamic> json) =>
      _$RestaurantListResItemFromJson(json);
}

@JsonSerializable()
class RestaurantMenuItem {
  final String id; // "1952a209-7c26-4f50-bc65-086f6e64dbbd",
  final String name; // "마라맛 코팩 떡볶이",
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl; // "/img/img.png",
  final String detail; // "서울에서 두번째로 맛있는 떡볶이집! 리뷰 이벤트 진행중~",
  final int price; // 8000

  RestaurantMenuItem({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantMenuItem.fromJson(Map<String, dynamic> json) =>
      _$RestaurantMenuItemFromJson(json);
}

@JsonSerializable()
class RestaurantShowRes extends RestaurantListResItem {
  final String detail; // "오늘 주문하면 배송비 3000원 할인!",
  final List<RestaurantMenuItem> products;

  RestaurantShowRes({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantShowRes.fromJson(Map<String, dynamic> json) =>
      _$RestaurantShowResFromJson(json);
}

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@JsonSerializable()
class RatingModel implements IModelWithId {
  final String id;
  final UserModel user;
  final int rating;
  final String content;
  @JsonKey(
    fromJson: DataUtils.listPathsToUrls,
  )
  final List<String> imgUrls;

  RatingModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.content,
    required this.imgUrls,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}

abstract class IModelWithId {
  final String id;

  IModelWithId({
    required this.id,
  });
}

@JsonSerializable()
class ProductModel implements IModelWithId {
  @override
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final int price;
  final RestaurantListResItem restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@JsonSerializable()
class BasketItemModel {
  final ProductModel product;
  final int count;

  BasketItemModel({
    required this.product,
    required this.count,
  });

  BasketItemModel copyWith({ProductModel? product, int? count}) {
    return BasketItemModel(
        product: product ?? this.product, count: count ?? this.count);
  }

  factory BasketItemModel.fromJson(Map<String, dynamic> json) =>
      _$BasketItemModelFromJson(json);
}

@JsonSerializable()
class PatchBasketBody {
  final List<PatchBasketBodyBasket> basket;

  PatchBasketBody({
    required this.basket,
  });

  Map<String, dynamic> toJson() => _$PatchBasketBodyToJson(this);
}

@JsonSerializable()
class PatchBasketBodyBasket {
  final String productId;
  final int count;

  PatchBasketBodyBasket({
    required this.productId,
    required this.count,
  });

  factory PatchBasketBodyBasket.fromJson(Map<String, dynamic> json) =>
      _$PatchBasketBodyBasketFromJson(json);

  Map<String, dynamic> toJson() => _$PatchBasketBodyBasketToJson(this);
}

@JsonSerializable()
class OrderProductModel {
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final int price;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);
}

@JsonSerializable()
class OrderProductAndCountModel {
  final OrderProductModel product;
  final int count;

  OrderProductAndCountModel({
    required this.product,
    required this.count,
  });

  factory OrderProductAndCountModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductAndCountModelFromJson(json);
}

@JsonSerializable()
class OrderModel implements IModelWithId {
  @override
  final String id;
  final List<OrderProductAndCountModel> products;
  final int totalPrice;
  final RestaurantListResItem restaurant;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.restaurant,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

@JsonSerializable()
class PostOrderBody {
  final String id;
  final List<PostOrderBodyProduct> products;
  final int totalPrice;
  final String createdAt;

  PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
  });

  factory PostOrderBody.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable()
class PostOrderBodyProduct {
  final String productId;
  final int count;

  PostOrderBodyProduct({
    required this.productId,
    required this.count,
  });

  factory PostOrderBodyProduct.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyProductFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyProductToJson(this);
}
