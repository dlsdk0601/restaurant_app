import 'package:flutter/material.dart';

class NestedChildScreen extends StatelessWidget {
  final String routerName;

  const NestedChildScreen({
    super.key,
    required this.routerName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(routerName),
    );
  }
}
