import 'package:flutter/material.dart';
import 'package:restaurant_app/common/component/custom_text_form_field.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';
import 'package:restaurant_app/common/view/root_tab.dart';
import 'package:restaurant_app/ex/data_utils.dart';
import 'package:restaurant_app/ex/dio_ex.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        /*
        * keyboardDismissBehavior 키보 숨기기 기능
        * ScrollViewKeyboardDismissBehavior.manual
        * => 키보드의 done 을 클릭해야 사라짐 (default)
        * ScrollViewKeyboardDismissBehavior.onDrag
        * => 드래그 하면 사라지게
        * */
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                const _SubTitle(),
                Image.asset(
                  "asset/img/misc/logo.png",
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hinText: "이메일을 입력해주세요.",
                  onChanged: (String value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hinText: "비밀번호을 입력해주세요.",
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await dioEx.signIn(
                      userName: userName,
                      password: password,
                    );

                    await DataUtils.setTokenStorage(res);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text("로그인"),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("회원가입"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "환영합니다!",
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)",
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
