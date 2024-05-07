import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/layout/default_layout.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go("/basic");
            },
            child: const Text("Go Basic"),
          )
        ],
      ),
    );
  }
}
