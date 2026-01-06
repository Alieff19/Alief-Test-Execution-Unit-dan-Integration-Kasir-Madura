import 'package:shared_preferences/shared_preferences.dart';

/// Helper class untuk autentikasi dan akses token
/// Menggantikan duplikasi _getToken() di berbagai service
class AuthHelper {
  /// Get JWT token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  /// Get role dari SharedPreferences
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  /// Get toko ID dari SharedPreferences
  static Future<int?> getTokoId() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.get('tokoId');
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    return null;
  }

  /// Save token ke SharedPreferences
  static Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString("jwt_token", token);
  }

  /// Clear all auth data
  static Future<bool> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
    await prefs.remove("role");
    await prefs.remove("tokoId");
    return true;
  }
}
