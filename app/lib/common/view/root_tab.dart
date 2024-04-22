import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "딜리버리",
      child: Center(
        child: Text("ROOT"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // BottomNavigationBarType.shifting 확대 애니메이션
        // BottomNavigationBarType.fixed 애니메이션 없음
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          print(index);
          setState(() {
            this.index = index;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: "음식",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "주문",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "프로필",
          ),
        ],
      ),
    );
  }
}
