import 'dart:io';

const ACCESS_TOKEN_KEY = "ACCESS_TOKEN";
const REFRESH_TOKEN_KEY = "REFRESH_TOKEN";
// const storage = FlutterSecureStorage();

// localhost
const String emulatorIp = "10.0.2.2:3000";
const String simulatorIp = "localhost:3000";

final String ip = Platform.isAndroid ? emulatorIp : simulatorIp;
