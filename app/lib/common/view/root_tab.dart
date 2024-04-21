import 'package:flutter/material.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';

class RootTab extends StatelessWidget {
  const RootTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text("ROOT"),
      ),
    );
  }
}
