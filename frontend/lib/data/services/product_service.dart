import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../../core/auth_helper.dart';
import '../../core/api_config.dart';

class ProductService {
  static String get baseUrl => '${ApiConfig.resolvedBaseUrl}/api/produk';

  // =========================================================
  // GET PRODUCTS
  // =========================================================
  Future<List<Product>> getProducts() async {
    final token = await AuthHelper.getToken();
    final prefs = await SharedPreferences.getInstance();

    final role = prefs.getString("role");
    final tokoId = prefs.getInt("toko_id");

    late String url;

    if (role == "ADMIN") {
      if (tokoId == null || tokoId == 0) {
        throw Exception("Admin belum memilih toko");
      }
      url = "$baseUrl/list?tokoId=$tokoId";
    } else {
      url = "$baseUrl/list"; // KASIR
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body["data"] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Gagal memuat produk (${response.statusCode})");
    }
  }

  // =========================================================
  // ADD PRODUCT (FINAL FIX)
  // =========================================================
  Future<bool> addProduct({
    required File imageFile,
    required String nama,
    required double hargaJual,
    required int stok,
    required String satuan,
    int? tokoId, // ADMIN saja
  }) async {
    final token = await AuthHelper.getToken();

    final uri = Uri.parse("$baseUrl/add");
    final request = http.MultipartRequest("POST", uri);
    request.headers["Authorization"] = "Bearer $token";

    // 🔥 WAJIB: kirim sebagai RequestPart("data")
    final data = {
      "nama": nama,
      "hargaJual": hargaJual,
      "stok": stok,
      "satuan": satuan,
      if (tokoId != null) "tokoId": tokoId,
    };

    request.files.add(
      http.MultipartFile.fromString(
        "data",
        jsonEncode(data),
        contentType: MediaType("application", "json"),
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath("image", imageFile.path),
    );

    final response = await request.send();
    print("ADD PRODUCT CODE: ${response.statusCode}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // =========================================================
  // UPDATE PRODUCT (FINAL FIX)
  // =========================================================
  Future<bool> updateProduct({
    required int id,
    required String nama,
    required double hargaJual,
    required int stok,
    required String satuan,
    File? imageFile,
  }) async {
    final token = await AuthHelper.getToken();

    final uri = Uri.parse("$baseUrl/update/$id");
    final request = http.MultipartRequest("PUT", uri);
    request.headers["Authorization"] = "Bearer $token";

    final data = {
      "nama": nama,
      "hargaJual": hargaJual,
      "stok": stok,
      "satuan": satuan,
    };

    request.files.add(
      http.MultipartFile.fromString(
        "data",
        jsonEncode(data),
        contentType: MediaType("application", "json"),
      ),
    );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );
    }

    final response = await request.send();
    print("UPDATE PRODUCT CODE: ${response.statusCode}");

    return response.statusCode == 200;
  }

  // =========================================================
  // DELETE PRODUCT
  // =========================================================
  Future<bool> deleteProduct(int id) async {
    final token = await AuthHelper.getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/delete/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}
