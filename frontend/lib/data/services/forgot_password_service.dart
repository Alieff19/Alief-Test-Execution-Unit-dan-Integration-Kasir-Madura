import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forgot_password_request.dart';
import '../models/forgot_password_response.dart';
import '../../core/api_config.dart';

class ForgotPasswordService {
  final String baseUrl = "${ApiConfig.resolvedBaseUrl}/api/auth";

  // Kirim OTP WA
  Future<ForgotPasswordResponse> sendOtp(ForgotPasswordRequest req) async {
    final url = Uri.parse('$baseUrl/send-otp');  // 🔥 FIXED

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );

    if (response.statusCode == 200) {
      return ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");
      throw Exception('Gagal mengirim OTP');
    }
  }
}
