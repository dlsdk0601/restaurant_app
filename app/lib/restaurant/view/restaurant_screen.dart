import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/ex/dio_ex.dart';
import 'package:restaurant_app/restaurant/component/restaurant_card.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantListResItem>> paginateRestaurant() async {
    final res = await dioEx.getRestaurantList(after: "", count: 20);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<RestaurantListResItem>>(
            future: paginateRestaurant(),
            builder: (
              context,
              AsyncSnapshot<List<RestaurantListResItem>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];

                  return RestaurantCard.fromModel(
                    model: item,
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
