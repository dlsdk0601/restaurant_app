import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/config.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:restaurant_app/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final res = await dioEx.getRestaurantList(after: "", count: 20);

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (
              context,
              AsyncSnapshot<List> snapshot,
            ) {
              if (!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];

                  return RestaurantCard(
                    image: Image.network(
                      "${ip}${item["thumbUrl"]}",
                      fit: BoxFit.cover,
                    ),
                    name: item["name"],
                    tags: List<String>.from(item["tags"]),
                    ratingsCount: item["ratingsCount"],
                    deliveryTime: item["deliveryTime"],
                    deliveryFee: item["deliveryFee"],
                    ratings: item["ratings"],
                  );
                },
                separatorBuilder: (_, index) {
                  return const SizedBox(
                    height: 16.0,
                  );
                },
                itemCount: snapshot.data!.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
