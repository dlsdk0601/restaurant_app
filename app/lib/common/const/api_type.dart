import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_app/ex/data_utils.dart';

part 'api_type.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class CursorPagination<T> {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({required this.meta, required this.data});

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({required this.count, required this.hasMore});

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
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
class RestaurantListResItem {
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
