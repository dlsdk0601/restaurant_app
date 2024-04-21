import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hinText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  const CustomTextFormField({
    super.key,
    required this.onChanged,
    this.hinText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText, // 비밃번호 Text 일때
      autofocus: autofocus, // 해당 화면에 왔을때 자동으로 바로 focus
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hinText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        errorText: errorText,
        fillColor: INPUT_BG_COLOR,
        filled: true, // 백그라운드 컬러를 넣을거냐는 파라미터, fiilColor 넣었으면 무조건 true 해줘야함
        border: baseBorder, // focus 아닐 때 style
        // focus 됬을 때 style
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
        enabledBorder: baseBorder,
      ),
    );
  }
}
