import 'dart:io' show Platform;

class ApiConfig {
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  static String get resolvedBaseUrl {
    // PRIORITAS: jika diberikan dari --dart-define
    if (baseUrl.isNotEmpty) return baseUrl;

    try {
      // ANDROID EMULATOR (hanya emulator)
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080";
      }

      // iOS SIMULATOR
      if (Platform.isIOS) {
        return "http://localhost:8080";
      }

      // WINDOWS / MAC / LINUX (termasuk Flutter WEB)
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        return "http://localhost:8080";
      }
    } catch (_) {
      // KALAU WEB (tidak ada Platform)
      return "http://localhost:8080";
    }

    return "http://localhost:8080";
  }
}
