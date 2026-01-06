import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../core/api_config.dart';
import '../../core/auth_helper.dart';
import '../models/laporan_harian.dart';

class LaporanService {
  String get baseUrl => '${ApiConfig.resolvedBaseUrl}/api/laporan';
  String get baseTokoUrl => '${ApiConfig.resolvedBaseUrl}/api/toko'; // endpoint daftar toko

  String _formatDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  // =========================================================
  // FETCH LAPORAN DARI BACKEND
  // =========================================================
  Future<List<DailyReport>> fetchLaporan({DateTime? tanggal, String? tokoNama}) async {
    try {
      final token = await AuthHelper.getToken();
      final role = await AuthHelper.getRole();
      final tokoId = await AuthHelper.getTokoId(); // untuk kasir

      // ================================
      // 1) BANGUN URL DINAMIS
      // ================================
      String url = baseUrl;

      // ADMIN → jika pilih toko, tambahkan tokoId
      if (role == "ADMIN" && tokoNama != null && tokoNama.isNotEmpty) {
        // convert tokoNama → tokoId (misal: index + 1 atau dari daftar backend)
        // Di sini asumsi tokoId disediakan backend, kamu bisa sesuaikan
        final semuaToko = await fetchAllToko();
        final t = semuaToko.firstWhere(
                (e) => e['namaToko'] == tokoNama,
            orElse: () => {'id': null}
        );
        if (t['id'] != null) {
          url += "?tokoId=${t['id']}";
        }
      }

      // Kasir → selalu kirim tokoId
      if (role != "ADMIN" && tokoId != null) {
        url += (url.contains("?") ? "&" : "?") + "tokoId=$tokoId";
      }

      // Tambahkan filter tanggal jika ada
      if (tanggal != null) {
        url += (url.contains("?") ? "&" : "?") + "tanggal=${_formatDate(tanggal)}";
      }

      print("Request URL: $url");

      // ================================
      // 2) REQUEST KE BACKEND
      // ================================
      final resp = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print("Response Code: ${resp.statusCode}");
      print("Response Body: ${resp.body}");

      if (resp.statusCode != 200) {
        throw Exception("Error ${resp.statusCode}: ${resp.body}");
      }

      final decoded = jsonDecode(resp.body);

      // Backend selalu return LIST laporan harian
      if (decoded is List) {
        return decoded.map((e) => DailyReport.fromJson(e)).toList();
      } else {
        throw Exception("Format backend tidak sesuai (harus LIST)");
      }
    } catch (e) {
      throw Exception("Gagal mengambil laporan: $e");
    }
  }

  // =========================================================
  // FETCH SEMUA TOKO UNTUK ADMIN
  // =========================================================
  Future<List<Map<String, dynamic>>> fetchAllToko() async {
    try {
      final token = await AuthHelper.getToken();

      final resp = await http.get(
        Uri.parse(baseTokoUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (resp.statusCode != 200) {
        throw Exception("Gagal ambil daftar toko: ${resp.body}");
      }

      final decoded = jsonDecode(resp.body);
      if (decoded is List) {
        // List of toko maps: [{'id': 1, 'namaToko': 'Madura 1'}, ...]
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception("Format backend tidak sesuai (harus LIST)");
      }
    } catch (e) {
      throw Exception("Gagal ambil daftar toko: $e");
    }
  }

  // =========================================================
  // HANYA AMBIL NAMA TOKO UNTUK DROPDOWN
  // =========================================================
  Future<List<String>> fetchAllTokoNames() async {
    final semua = await fetchAllToko();
    return semua.map((e) => e['namaToko'] as String).toList();
  }
}
