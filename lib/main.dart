import 'package:actual/common/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: _App(),
  ));
}

// 만약 모든 스크린에 들어가는 위젯들이 있으면 레이아웃으로 감싸는걸 추천함
// => DefaultLayout 위젯

class _App extends StatelessWidget {
  const _App();

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // 최상위 위젯에는 무조건 MaterialApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      theme: ThemeData(fontFamily: 'NotoSans'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
