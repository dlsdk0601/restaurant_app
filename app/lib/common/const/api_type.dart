class SignInRes {
  final String refreshToken;
  final String accessToken;

  SignInRes({required this.refreshToken, required this.accessToken});
}

enum RestaurantPriceRange { cheap, medium, expensive }

class RestaurantListResItem {
  final String id; // "1952a209-7c26-4f50-bc65-086f6e64dbbd",
  final String name; // "우라나라에서 가장 맛있는 짜장면집",
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

  factory RestaurantListResItem.fromJson({required Map<String, dynamic> json}) {
    return RestaurantListResItem(
      id: json["id"],
      name: json["name"],
      thumbUrl: json["thumbUrl"],
      tags: List<String>.from(json["tags"]),
      priceRange: RestaurantPriceRange.values.firstWhere(
        (e) => e.name == json["priceRange"],
      ),
      ratings: json["ratings"],
      ratingsCount: json["ratingsCount"],
      deliveryTime: json["deliveryTime"],
      deliveryFee: json["deliveryFee"],
    );
  }
}
