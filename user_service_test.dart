import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kasirmadura/core/api_config.dart';
import 'package:kasirmadura/core/auth_helper.dart';
import 'package:kasirmadura/data/models/user_request.dart';
import 'package:kasirmadura/data/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late UserService userService;
  late MockClient mockClient;

  // Setup SharedPreferences for AuthHelper
  setUpAll(() {
    SharedPreferences.setMockInitialValues({'jwt_token': 'mock_token_admin'});
  });

  setUp(() {
    mockClient = MockClient((request) async {
      final url = request.url.toString();
      final headers = request.headers;
      final method = request.method;
      print("MOCK USER REQ: $method $url HEADERS: $headers");

      // TC-15: Akses user dengan KASIR (Negative Case)
      if (headers['Authorization'] == 'Bearer mock_token_kasir') {
        return http.Response('Forbidden', 403);
      }

      // TC-14: Get all users (Admin)
      if (url.endsWith('/api/users') && request.method == 'GET') {
         // Allow any token for now to verify logic first, or strict check
         return http.Response(jsonEncode([
            {"id": 1, "username": "admin", "role": "ADMIN", "phone": "081"},
            {"id": 2, "username": "kasir1", "role": "KASIR", "phone": "082"}
          ]), 200);
      }



      // TC-16: Create user
      if (url.endsWith('/api/users/add') && request.method == 'POST') {
        final body = jsonDecode(request.body);
        if (body['username'] == 'newuser') {
          return http.Response(jsonEncode({
            "success": true,
            "data": {"id": 3, "username": "newuser", "role": "KASIR"}
          }), 200);
        }
      }

      // TC-17: Delete user
      if (url.contains('/api/users/') && request.method == 'DELETE') {
        if (url.endsWith('/99')) { // TC-18 Invalid
           return http.Response('Not Found', 404);
        }
        return http.Response(jsonEncode({"success": true}), 200); // TC-17 Valid
      }

      return http.Response('Not Found', 404);
    });

    userService = UserService(client: mockClient);
  });

  group('UserService Tests', () {
    // TC-14
    test('TC-14: Get all users (Admin) returns list of users', () async {
      final users = await userService.getAllUsers();
      expect(users, isNotEmpty);
      expect(users.length, 2);
      expect(users[0].username, 'admin');
    });

    // TC-15
    test('TC-15: Akses user dengan KASIR returns 403 / empty list (Negative Case)', () async {
      SharedPreferences.setMockInitialValues({'jwt_token': 'mock_token_kasir'});
      // Re-init service or helper might be needed if token reads are real-time, 
      // but userService reads token inside method. 
      // Warning: AuthHelper might be static.

      // We need to re-mock or ensure getTokens reads from SP every time.
      // Assuming AuthHelper.getToken() reads from SP.
      
      final users = await userService.getAllUsers();
      expect(users, isEmpty);
    });

    // TC-16
    test('TC-16: Create user returns success', () async {
        SharedPreferences.setMockInitialValues({'token': 'mock_token_admin'});
        final req = UserRequest(username: 'newuser', password: '123', phone: '08123');
        final response = await userService.createUser(req);
        
        expect(response.success, true);
        expect(response.data['data']['username'], 'newuser');
    });

    // TC-17
    test('TC-17: Delete user valid returns success', () async {
      final success = await userService.deleteUser(1);
      expect(success, true);
    });

    // TC-18
    test('TC-18: Delete user invalid returns failure (404)', () async {
      final success = await userService.deleteUser(99);
      expect(success, false);
    });
  });
}
