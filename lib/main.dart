import 'package:flutter/material.dart';
import 'package:restaurant_app/common/component/custom_text_form_field.dart';

void main() {
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hinText: "이메일을 입력해주세요.",
              onChanged: (String value) {},
            ),
            CustomTextFormField(
              hinText: "비밀번호을 입력해주세요.",
              onChanged: (String value) {},
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}
