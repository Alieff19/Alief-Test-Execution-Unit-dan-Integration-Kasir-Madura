import 'package:flutter/material.dart';
import '../data/models/Kasir.dart';
import '../data/models/user_request.dart';
import '../data/services/user_service.dart';

class KasirController extends ChangeNotifier {
  final UserService service;

  KasirController({UserService? service}) : service = service ?? UserService();

  List<Kasir> items = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    items = await service.getAllUsers();
    loading = false;
    notifyListeners();
  }

  Future<bool> addKasir(String username, String password, String phone) async {
    try {
      loading = true;
      notifyListeners();

      final request = UserRequest(
        username: username,
        password: password,
        phone: phone,
      );

      final response = await service.createUser(request);

      if (response.success) {
        await load();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Add kasir error: $e");
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteKasir(int id) async {
    try {
      final success = await service.deleteUser(id);
      if (success) {
        items.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Delete kasir error: $e");
      return false;
    }
  }

  Future<bool> updateKasir(int id, String nama, String telp) async {
    try {
      loading = true;
      notifyListeners();

      final data = {
        "username": nama,
        "phone": telp,
      };

      final success = await service.updateUser(id, data);

      if (success) {
        await load();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Update kasir error: $e");
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
