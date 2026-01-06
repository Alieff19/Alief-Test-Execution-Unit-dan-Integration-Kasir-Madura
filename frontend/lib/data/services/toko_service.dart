import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/toko.dart';
import '../../core/auth_helper.dart';
import '../../core/api_config.dart';

class TokoService {
  final http.Client client;
  TokoService({http.Client? client}) : client = client ?? http.Client();

  String get baseUrl => '${ApiConfig.resolvedBaseUrl}/api/toko';

  // ============================================================
  // TAMBAH TOKO
  // Backend return: object Toko langsung
  // ============================================================
  Future<Toko?> tambahToko(Map<String, dynamic> body) async {
    final token = await AuthHelper.getToken() ?? "";

    print("====== ADD TOKO ======");
    print("URL: $baseUrl/add");
    print("BODY: ${jsonEncode(body)}");

    final response = await client.post(
      Uri.parse("$baseUrl/add"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }

    return Toko.fromJson(jsonDecode(response.body));
  }

  // ============================================================
  // UPDATE TOKO
  // Backend return: object Toko langsung
  // ============================================================
  Future<Toko?> updateToko(int id, Map<String, dynamic> body) async {
    final token = await AuthHelper.getToken() ?? "";

    print("====== UPDATE TOKO ======");
    print("URL: $baseUrl/$id");
    print("BODY: ${jsonEncode(body)}");

    final response = await client.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) return null;

    return Toko.fromJson(jsonDecode(response.body));
  }

  // ============================================================
  // GET TOKO BY KASIR ID
  // ============================================================
  Future<Toko?> getTokoByKasir(int kasirId) async {
    final token = await AuthHelper.getToken() ?? "";

    print("====== GET TOKO BY KASIR ======");
    print("URL: $baseUrl/kasir/$kasirId");

    final response = await client.get(
      Uri.parse("$baseUrl/kasir/$kasirId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) return null;

    if (response.body.isEmpty || response.body == "null") {
      return null;
    }

    return Toko.fromJson(jsonDecode(response.body));
  }

  // ============================================================
  // GET SEMUA TOKO
  // Backend return: array Toko
  // ============================================================
  Future<List<Toko>> getTokoList() async {
    final token = await AuthHelper.getToken() ?? "";

    print("====== GET ALL TOKO ======");
    print("URL: $baseUrl");

    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) return [];

    final List data = jsonDecode(response.body);
    return data.map((e) => Toko.fromJson(e)).toList();
  }

  // ============================================================
  // DELETE TOKO
  // ============================================================
  Future<bool> deleteToko(int tokoId) async {
    final token = await AuthHelper.getToken() ?? "";

    print("====== DELETE TOKO ======");
    print("URL: $baseUrl/$tokoId");

    final response = await client.delete(
      Uri.parse("$baseUrl/$tokoId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS: ${response.statusCode}");

    return response.statusCode == 200;
  }
}

