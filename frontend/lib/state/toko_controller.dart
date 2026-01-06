import 'package:flutter/foundation.dart';
import '../data/models/toko.dart';
import '../data/services/toko_service.dart';

class TokoController extends ChangeNotifier {
  Toko? selectedToko; // toko yang dipilih admin/kasir
  List<Toko> items = []; // daftar semua toko
  bool loading = false;

  final TokoService service;
  TokoController({TokoService? service}) : service = service ?? TokoService();
  TokoController.http() : service = TokoService();

  // ============================================================
  // SET TOKO TERPILIH LANGSUNG
  // ============================================================
  void setSelectedToko(Toko toko) {
    selectedToko = toko;
    notifyListeners();
  }

  // ============================================================
  // SET TOKO TERPILIH PAKAI ID (UNTUK KASIR)
  // ============================================================
  void setSelectedTokoById(int tokoId) {
    final toko = items.firstWhere(
          (t) => t.id == tokoId,
      orElse: () => Toko(id: tokoId, namaToko: 'Toko', alamat: ''),
    );

    selectedToko = toko;
    notifyListeners();
  }

  // ============================================================
  // LOAD SEMUA TOKO
  // ============================================================
  Future<void> loadToko() async {
    loading = true;
    notifyListeners();

    try {
      final list = await service.getTokoList();
      if (list != null) items = list;
    } catch (e) {
      debugPrint("Error loadToko: $e");
    }

    loading = false;
    notifyListeners();
  }

  // ============================================================
  // TAMBAH TOKO
  // ============================================================
  Future<void> tambahToko({
    required String namaToko,
    required String alamat,
    required int kasirId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final tokoBaru = await service.tambahToko({
        "namaToko": namaToko,
        "alamat": alamat,
        "kasirId": kasirId
      });

      if (tokoBaru != null) {
        items.add(tokoBaru);
        selectedToko = tokoBaru;
      }
    } catch (e) {
      debugPrint("Error tambahToko: $e");
    }

    loading = false;
    notifyListeners();
  }

  // ============================================================
  // UPDATE TOKO
  // ============================================================
  Future<void> updateToko({
    required int tokoId,
    required String namaToko,
    required String alamat,
    required int kasirId,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final data = {
        "namaToko": namaToko,
        "alamat": alamat,
        "kasirId": kasirId,
      };

      final tokoUpdated = await service.updateToko(tokoId, data);

      if (tokoUpdated != null) {
        final index = items.indexWhere((t) => t.id == tokoId);
        if (index != -1) items[index] = tokoUpdated;
        if (selectedToko?.id == tokoId) selectedToko = tokoUpdated;
      }
    } catch (e) {
      debugPrint("Error updateToko: $e");
    }

    loading = false;
    notifyListeners();
  }

  // ============================================================
  Future<void> deleteToko(int tokoId) async {
    loading = true;
    notifyListeners();
    try {
      final success = await service.deleteToko(tokoId);
      if (success) {
        items.removeWhere((t) => t.id == tokoId);
      }
    } catch (e) {
      debugPrint("Error deleteToko: $e");
    }
    loading = false;
    notifyListeners();
  }

  // ============================================================
  void clear() {
    selectedToko = null;
    items = [];
    notifyListeners();
  }
}


