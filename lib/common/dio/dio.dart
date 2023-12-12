// ignore_for_file: public_member_api_docs, sort_constructors_first
// 인터셉터 기능은 정말 유용하다.
// 인터셉터는 요청과 응답을 가로채서 가공할 수 있기 때문이다.

// 캐싱을 따로 추가적으로 해줘야 하는 경우가 아니라면 관련된 변수들 or 클래스가 선언되어
// 있는 파일안에 같이 넣어주는 경우도 있다.(많이 사용함)

import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptors(storage: storage),
  );

  return dio;
});

class CustomInterceptors extends Interceptor {
  final FlutterSecureStorage storage;
  // storage도 같이 사용한다.
  CustomInterceptors({
    required this.storage,
  });

  // 1) 요청을 보낼때 ( 토큰을 자동으로 적용하는 코드 작성 )
  // 요청이 보내질대마다 만약에 Header에 accessToken: true 라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서 ) authorization:bearer $token 으로 헤더를 변경한다.

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 이런식으로 로그로도 사용할 수가 있다.
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      // 유효한 토큰이 없다면,
      // 헤더 삭제
      options.headers.remove('accessToken');

      // 실제 토큰으로 대체
      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      // 실제 토큰으로 대체
      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler); // 실제 요청 보낼때는 여기
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 발생했을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    // 401에러 (토큰에 문제가 있을 때)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.
    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    // 이런 식으로 로깅을 할 수도 있다.

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken이 아예 없으면
    // 당연히 에러를 던진다.
    if (refreshToken == null) {
      // 애러룰 던지는 방법 handler.reject를 사용한다.
      return handler.reject(err); // 에러 발생
    }

    final inStatus401 = err.response?.statusCode == 401;

    final isPathRefresh = err.requestOptions.path == '/auth/token';
    // 401 에러이거나 토큰을 새로발급받는 요청이 아니었다면
    if (inStatus401 && isPathRefresh) {
      final dio = Dio();

      try {
        final res = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = res.data['accessToken'];

        final options = err.requestOptions;
        options.headers.addAll({'authorization': 'Bearer $accessToken'});
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 똑같은 요청을 토큰만 새로 발급받아서 다시 보낸다.
        final response = await dio.fetch(options);

        return handler.resolve(response);
        // 에러 없이 실제로 요청이 잘 끝났다 라는 ( 에러가 나지 않은 것처럼 착각 )
        // 의미로 resolve를 사용한다.
      } on DioError {
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }
}
