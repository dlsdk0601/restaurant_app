import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const/colors.dart';
import 'package:restaurant_app/common/layout/default_layout.dart';
import 'package:restaurant_app/product/view/product_screen.dart';

import '../../restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;

  // late => 나중에 선언 될거다
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    // length => 몇개의 화면을 컨트롤 할거냐
    // vsync => 현재 state 를 넣어준다. this
    tabController = TabController(length: 4, vsync: this);

    // addListner
    tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    // addEvent 를 넣었으니까 dispose 해준다.
    tabController.dispose();

    super.dispose();
  }

  // event 를 넣어줘서 tabController.index 가 바뀔때마다 this.index 가 바뀌게 한다.
  void tabListener() {
    setState(() {
      index = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "딜리버리",
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
          tabController.animateTo(index);
        },
        // 아래 코드가 안되는 이유는 tabcontroller 의 index 가 바뀌긴 하지만, rendering 이 다시 되지 않아서 그렇다.
        // currentIndex: tabController.index,
        currentIndex: index,
        items: const [
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
      child: TabBarView(
        // default 가 좌우로 스크롤 하면 tab 이 바뀌는 구조인데,
        // 위아래 스크롤 넣을거기 때문에 ux 상 불편해서
        // 기본 스크롤을 없애기 위해 NeverScrollableScrollPhysics 추가
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Container(
            child: Center(child: Text("주문")),
          ),
          Container(
            child: Center(child: Text("프로필")),
          )
        ],
      ),
    );
  }
}
