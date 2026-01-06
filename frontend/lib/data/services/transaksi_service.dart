import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaksi.dart';
import '../../core/auth_helper.dart';
import '../../core/api_config.dart';

class TransaksiService {
  static String get baseUrl => '${ApiConfig.resolvedBaseUrl}/api/transaksi';

  // CREATE TRANSAKSI
  Future<Transaksi> createTransaksi(Transaksi transaksi) async {
    try {
      final token = await AuthHelper.getToken();

      if (token == null) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(transaksi.toJson()),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      // TOKEN INVALID / EXPIRED
      if (response.statusCode == 403 || response.statusCode == 401) {
        throw Exception("Token expired atau tidak valid. Silakan login ulang.");
      }

      if (response.statusCode == 200) {
        return Transaksi.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Gagal menyimpan transaksi: $e");
    }
  }

  // GET ALL TRANSAKSI
  Future<List<Transaksi>> getAllTransaksi() async {
    try {
      final token = await AuthHelper.getToken();

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception("Token expired. Silakan login ulang.");
      }

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Transaksi.fromJson(json)).toList();
      } else {
        throw Exception("Gagal mengambil transaksi");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // GET TRANSAKSI HARI INI
  Future<List<Transaksi>> getTransaksiToday() async {
    try {
      final token = await AuthHelper.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/today'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception("Token expired. Silakan login ulang.");
      }

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Transaksi.fromJson(json)).toList();
      } else {
        throw Exception("Gagal mengambil transaksi hari ini");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
