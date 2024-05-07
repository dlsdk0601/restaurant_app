import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NestedScreen extends StatelessWidget {
  final Widget child;

  const NestedScreen({
    super.key,
    required this.child,
  });

  int getIndex(BuildContext context) {
    if (GoRouterState.of(context).uri.path == "/nested/a") {
      return 0;
    }

    if (GoRouterState.of(context).uri.path == "/nested/b") {
      return 1;
    }

    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GoRouterState.of(context).uri.path),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getIndex(context),
        onTap: (index) {
          if (index == 0) {
            context.go("/nested/a");
            return;
          }

          if (index == 1) {
            context.go("/nested/b");
            return;
          }

          context.go("/nested/c");
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "person",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "notifications",
          ),
        ],
      ),
    );
  }
}
