import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_request.dart';
import '../models/signup_response.dart';
import '../../core/api_config.dart';

class SignupService {
  String get baseUrl => '${ApiConfig.resolvedBaseUrl}/api';

  Future<SignupResponse> signup(UserRequest request) async {
    final url = Uri.parse('$baseUrl/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: '${response.body}'");

      if (response.body.isEmpty) {
        throw Exception("Signup gagal: Server tidak mengirim respon (body kosong).");
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SignupResponse.fromJson(data);
      } else {
        final errorMsg = data['message'] ?? data['error'] ?? response.body;
        throw Exception("Signup gagal: $errorMsg");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
