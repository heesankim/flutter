import 'package:actual/common/const/data.dart';

class DataUtils {
  // 무조건 static이어야한다.
  static pathToUrl(String value) {
    return "http://$ip$value";
  }
}
