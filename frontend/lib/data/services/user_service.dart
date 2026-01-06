import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_request.dart';
import '../models/Kasir.dart';
import '../../core/auth_helper.dart';
import '../../core/api_config.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({required this.success, required this.message, this.data});
}

class UserService {
  final http.Client client;
  UserService({http.Client? client}) : client = client ?? http.Client();

  String get baseUrl => '${ApiConfig.resolvedBaseUrl}/api/users';

  /// ==============================
  /// CREATE USER (AUTOMATIC KASIR)
  /// ==============================
  Future<ApiResponse> createUser(UserRequest request) async {
    final token = await AuthHelper.getToken() ?? "";

    final url = Uri.parse("$baseUrl/add"); // endpoint sesuai controller

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // WAJIB TOKEN
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return ApiResponse(
        success: true,
        message: "User berhasil ditambahkan",
        data: json,
      );
    }

    return ApiResponse(
      success: false,
      message: "Gagal menambah user (${response.statusCode}): ${response.body}",
    );
  }

  Future<List<Kasir>> getAllUsers() async {
    final token = await AuthHelper.getToken() ?? '';
    final response = await client.get(Uri.parse(baseUrl), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Kasir.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> deleteUser(int id) async {
    final token = await AuthHelper.getToken() ?? '';
    final response = await client.delete(Uri.parse('$baseUrl/$id'), headers: {'Authorization': 'Bearer $token'});
    return response.statusCode == 200;
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    final token = await AuthHelper.getToken() ?? '';
    final response = await client.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(data)
    );
    return response.statusCode == 200;
  }
}
