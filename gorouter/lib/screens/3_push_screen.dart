import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/layout/default_layout.dart';

class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              // 현재 router stack 에 바로 push 하기 때문에
              // basic 갔다가 뒤로 가면 현재 스크린으로 다시 온다.
              context.push("/basic");
            },
            child: const Text("Push Basic"),
          ),
          ElevatedButton(
            onPressed: () {
              // router 에 정의된 중첩된 path 대로 이동해서
              // go 한 후에 뒤로가기 하면 / 스크린으로 가게 된다.
              context.go("/basic");
            },
            child: const Text("Go Basic"),
          ),
        ],
      ),
    );
  }
}
