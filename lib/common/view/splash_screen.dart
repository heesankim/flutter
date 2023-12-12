import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 토큰을 갖고있는지 아닌지 확인을 하고, 토큰이 있으면 홈화면으로 가고 아니면 로그인페이지로 간다.
// 기본로직은 이러한 식으로 작동한다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // initState는 await 할 수 없다.

    // deleteToken();
    checkToken();

    // checkToken이 끝날때까지 splashScreen화면을 계속 보게 될 것
  }

  void deleteToken() async {
    final storage = ref.read(secureStorageProvider);

    await storage.deleteAll();
  }

  // 토큰이 유효한지도 검사해야하는데 여기서는 일단 생략함.
  // 토큰이 있는지 검사 -> 있다면 엑세스토큰이 만료됐는지 검사 -> 만료됐다면 refreshToken이
  // 있는지 검사 -> 있다면 엑세스토큰 재발급, 없다면 로그아웃시켜서 재로그인 유저에게 요구...
  void checkToken() async {
    final storage = ref.read(secureStorageProvider);

    final String? refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    try {
      final res = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {'authorization': 'Bearer $refreshToken'},
        ),
      );
      // 지금 여기 안에서는 일단 가지고 있는 리프레쉬토큰으로 auth/token에 요청보내서 엑세스토큰 재발급받음.

      await storage.write(
          key: ACCESS_TOKEN_KEY, value: res.data['accessToken']);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const RootTab(),
        ),
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }

    // 현재 로컬에서 개발중이어서 서버 로딩 현실감을 주려고 세팅한 값
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroudColor: PRIMARY_COLOR,
      child: SizedBox(
        // 너비를 최대로 가져가기 위해 sizedbox로 감싼 후 width 설정을 해준다.
        // width: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
