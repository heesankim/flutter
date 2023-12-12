import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  // 탭컨트롤러는 따로 세팅이 필요하다 -> 사용하려면 with SingleTickerProviderStateMixin
  late TabController controller;
  // 만약 TabController? controller;해버리면 사용할때마다 null처리를 해줘야한다.
  // late 해주고, "언젠가는 controller를 사용할거고 사용할때쯤에는 무조건 선언되있을거야." 라는 걸 가정함.
  int index = 0;

  @override
  void initState() {
    super.initState();
    // vsync에는 컨트롤러는 선언하는 현재 state 또는 statefulWidget을 넣어주면 된다.
    controller = TabController(length: 4, vsync: this);
    // TODO: vsync에 this를 넣고 싶으면 with SingleTickerProviderStateMixin 해줘야 한다.
    // 애니메이션과 관련된 컨트롤러들은 이러한 세팅을 해주는 경우가 있다.
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // BottomNavigationBarType.sfifting  -> 선택된 탭이 조금 더 크게 표현된다.
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: '프로필',
          )
        ],
      ),
      child: TabBarView(
        // NeverScrollableScrollPhysics 이설정을 하면 탭바뷰를 가로스크롤로 이동할 수 없다.
        // 오로지 바텀네비게이션바 로만 이동할 수 있다.
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          RestaurantScreen(),
          Center(child: Text("음식")),
          Center(child: Text("주문")),
          Center(child: Text("프로필")),
        ],
      ),
    );
  }
}
