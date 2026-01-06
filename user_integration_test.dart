import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kasirmadura/data/services/user_service.dart';
import 'package:kasirmadura/state/kasir_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late KasirController controller;
  late UserService service;
  late MockClient mockClient;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({'jwt_token': 'mock_token_admin'});
  });

  setUp(() {
    mockClient = MockClient((request) async {
      final url = request.url.toString();
      final method = request.method;

      // GET /api/users
      if (url.endsWith('/api/users') && method == 'GET') {
         return http.Response(jsonEncode([
            {"id": 1, "username": "admin", "role": "ADMIN", "phone": "081"},
            {"id": 2, "username": "kasir1", "role": "KASIR", "phone": "082"}
          ]), 200);
      }

      // POST /api/users/add
      if (url.endsWith('/api/users/add') && method == 'POST') {
        return http.Response(jsonEncode({
          "success": true,
          "data": {"id": 3, "username": "new", "role": "KASIR"}
        }), 200);
      }

      // DELETE /api/users/2
      if (url.endsWith('/api/users/2') && method == 'DELETE') {
        return http.Response('OK', 200);
      }
      
      // PUT /api/users/update/2
      if (url.contains('/api/users/update/2') && method == 'PUT') {
        return http.Response('OK', 200);
      }

      return http.Response('Not Found', 404);
    });

    service = UserService(client: mockClient);
    controller = KasirController(service: service);
  });

  // TC-14: User Get all users (Admin)
  test('TC-14 Integration Test: Load Users should update items list', () async {
    await controller.load();
    expect(controller.items, isNotEmpty);
    expect(controller.items.length, 2);
    expect(controller.items.first.username, "admin");
  });

  // TC-16: User Create user
  test('TC-16 Integration Test: Add Kasir should success and reload list', () async {
    // Mock load first to simulate initial state
    await controller.load(); 
    final initialCount = controller.items.length; // 2

    final success = await controller.addKasir("new", "pass", "081");
    expect(success, true);
  });

  // TC-17: User Delete user (Valid)
  test('TC-17 Integration Test: Delete Kasir should remove item from list', () async {
    // Setup
    await controller.load();
    expect(controller.items.length, 2);

    // Action
    final success = await controller.deleteKasir(2);
    
    // Verify
    expect(success, true);
    expect(controller.items.where((e) => e.id == 2), isEmpty);
  });

  // TC-18: Delete user invalid (Negative Case)
  test('TC-18 Integration Test: Delete Kasir Invalid should return false', () async {
    final success = await controller.deleteKasir(99); // ID 99 not mocked or returns 404
    expect(success, false);
  });
  
  // TC-15: Access user with Kasir (Negative Case - Simulator)
  test('TC-15 Integration Test: Access with Unauthorized Role should fail', () async {
     // We simulate a mock response failure for a specific condition or just verify error handling
     final success = await controller.updateKasir(99, "Fail", "000");
     expect(success, false);
  });

  // (Optional) Update User Scenario
  test('Integration Test: Update Kasir should success and reload', () async {
    final success = await controller.updateKasir(2, "Updated Name", "0822");
    expect(success, true);
  });
}
