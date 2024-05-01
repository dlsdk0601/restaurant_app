import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/component/custom_text_form_field.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/common/const/data.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';
import 'package:restaurant_app/common/secure_storage/secure_storage.dart';
import 'package:restaurant_app/common/view/root_tab.dart';
import 'package:restaurant_app/ex/data_utils.dart';
import 'package:restaurant_app/user/repository/user_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userName = '';
  String password = '';

  Future<void> onPressSignIn() async {
    final token = DataUtils.signInToken("$userName:$password");

    final res = await ref.watch(userRepositoryProvider).signIn(token: token);
    setToken(res);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RootTab(),
      ),
    );
  }

  Future<void> setToken(SignInRes res) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(
      key: REFRESH_TOKEN_KEY,
      value: res.refreshToken,
    );
    await storage.write(
      key: ACCESS_TOKEN_KEY,
      value: res.accessToken,
    );
  }

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
                  onPressed: onPressSignIn,
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
