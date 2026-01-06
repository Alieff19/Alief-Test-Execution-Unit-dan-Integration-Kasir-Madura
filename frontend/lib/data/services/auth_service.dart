import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../core/api_config.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  final String baseUrl = ApiConfig.resolvedBaseUrl;

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/api/login');

    print("POST Login ke: $url");
    print("Body: username=${request.username}, password=******");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    print("Status Code: ${response.statusCode}");
    print("Raw Body: ${response.body}");

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final String token = data['token'];

      // Decode JWT (buat role)
      final Map<String, dynamic> decoded = JwtDecoder.decode(token);
      final String role = decoded['role'] ?? "";

      // 🔥 AMBIL tokoId DARI RESPONSE BACKEND
      final int? tokoId = data['tokoId'] != null
          ? int.tryParse(data['tokoId'].toString())
          : null;

      // Simpan basic auth
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt_token", token);
      await prefs.setString("role", role);
      await prefs.setString("username", request.username);

      // ⚠️ JANGAN simpan tokoId di sini lagi
      // LoginPage yang handle admin vs kasir

      return LoginResponse(
        token: token,
        role: role,
        message: data['message'] ?? 'Login berhasil',
        tokoId: tokoId, // ✅ INI KUNCI
      );
    }

    // LOGIN GAGAL
    return LoginResponse(
      token: "",
      role: "",
      message: data['message'] ?? 'Login gagal',
      tokoId: null,
    );
  }

  // ---------------------------------------------------------------------------
  // RESET PASSWORD
  // ---------------------------------------------------------------------------
  Future<bool> resetPassword(String phone, String newPassword) async {
    final url = Uri.parse('$baseUrl/api/auth/reset-password');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "newPassword": newPassword,
      }),
    );

    print("POST Reset Password ke: $url");
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    return response.statusCode == 200;
  }
}
