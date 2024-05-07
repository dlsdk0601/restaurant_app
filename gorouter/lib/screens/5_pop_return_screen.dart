import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/layout/default_layout.dart';

class PopReturnScreen extends StatelessWidget {
  const PopReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              // 꼭 String 말고도 class, list, Map 등 넣을수 있다. 대신에 하나만
              context.pop("Hello World");
            },
            child: const Text("Pop"),
          ),
        ],
      ),
    );
  }
}
