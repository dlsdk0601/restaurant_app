import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/layout/default_layout.dart';

class QueryParameterScreen extends StatelessWidget {
  const QueryParameterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          Text(
              "Query Parameter: ${GoRouterState.of(context).uri.queryParameters}"),
          ElevatedButton(
            onPressed: () {
              context.push(
                Uri(
                  path: "/query_param",
                  queryParameters: {
                    "name": "hello",
                    "age": "32",
                  },
                ).toString(),
              );
            },
            child: const Text("Query Parameter"),
          )
        ],
      ),
    );
  }
}
