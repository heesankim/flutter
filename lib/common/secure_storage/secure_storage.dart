import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 한번 이 secureStorageProvider가 생성이 되서 반환이 되면 이 값을 이 프로젝트 안에서
// 계속 사용하기 위해서 이렇게 선언한다.
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);


// Provider 를 사용하면 어떠한 스크린에서도 똑같은 인스턴스르 불러올 수 있다.