import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/product.dart';
import '../data/services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _items = [];
  List<Product> get items => _items;

  bool isLoading = false;

  // ================= GET TOKO ID =================
  Future<int?> _getTokoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("toko_id");
  }

  // ================= LOAD PRODUCTS =================
  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      _items = await _service.getProducts();
    } catch (e) {
      debugPrint("Gagal load produk: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= ADD PRODUCT =================
  Future<bool> add(Product p, File imageFile) async {
    try {
      final tokoId = await _getTokoId();
      debugPrint("ADD PRODUCT => tokoId: $tokoId");

      final ok = await _service.addProduct(
        imageFile: imageFile,
        nama: p.nama,
        hargaJual: p.hargaJual,
        stok: p.stok,
        satuan: p.satuan,
        tokoId: tokoId, // 🔥 FIX UTAMA
      );

      if (ok) {
        await loadProducts();
        return true;
      }

      debugPrint("Gagal tambah produk");
      return false;
    } catch (e) {
      debugPrint("Error add product: $e");
      return false;
    }
  }

  // ================= UPDATE PRODUCT =================
  Future<bool> update(Product p, {File? imageFile}) async {
    try {
      final ok = await _service.updateProduct(
        id: p.id,
        nama: p.nama,
        hargaJual: p.hargaJual,
        stok: p.stok,
        satuan: p.satuan,
        imageFile: imageFile,
      );

      if (ok) {
        await loadProducts();
        return true;
      }

      debugPrint("Gagal update produk");
      return false;
    } catch (e) {
      debugPrint("Error update: $e");
      return false;
    }
  }

  // ================= DELETE PRODUCT =================
  Future<bool> delete(int id) async {
    try {
      final ok = await _service.deleteProduct(id);

      if (ok) {
        _items.removeWhere((p) => p.id == id);
        notifyListeners();
        return true;
      }

      debugPrint("Gagal hapus produk");
      return false;
    } catch (e) {
      debugPrint("Error delete: $e");
      return false;
    }
  }
}
