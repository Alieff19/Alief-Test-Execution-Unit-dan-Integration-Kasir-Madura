import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kasirmadura/data/models/toko.dart';
import 'package:kasirmadura/data/services/toko_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late TokoService tokoService;
  late MockClient mockClient;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({'jwt_token': 'mock_token_admin'});
  });

  setUp(() {
    mockClient = MockClient((request) async {
      final url = request.url.toString();
      final method = request.method;

      // TC-19: Tambah Toko
      if (url.endsWith('/api/toko/add') && method == 'POST') {
        final body = jsonDecode(request.body);
        if (body['namaToko'] == 'Toko Baru') {
          // Return Toko JSON
          return http.Response(jsonEncode({
             "id": 10, 
             "namaToko": "Toko Baru", 
             "alamat": "Jalan Baru", 
             "kasirId": 2,
             "kasirName": "Kasir 1"
          }), 200);
        }
      }

      // TC-20: Update Toko
      if (url.contains('/api/toko/') && method == 'PUT') {
        final body = jsonDecode(request.body);
        // Assuming update returns the updated object or just 200 OK
        return http.Response(jsonEncode(body), 200);
      }

      // TC-21 & TC-22: Delete Toko
      if (url.contains('/api/toko/') && method == 'DELETE') {
        if (url.endsWith('/99')) { // TC-22 Invalid
           return http.Response('Not Found', 404);
        }
        return http.Response('OK', 200); // TC-21 Valid
      }

      // TC-23: Get Toko by Kasir/Admin
      if (url.endsWith('/api/toko') && method == 'GET') {
         return http.Response(jsonEncode([
            {"id": 5, "namaToko": "Toko Lama", "alamat": "Jalan Lama", "kasirId": 2}
         ]), 200);
      }

      return http.Response('Not Found', 404);
    });

    tokoService = TokoService(client: mockClient);
  });

  group('TokoService Tests', () {
    // TC-19
    test('TC-19: Tambah Toko returns Toko object success', () async {
      final newToko = await tokoService.tambahToko({
        "namaToko": "Toko Baru", 
        "alamat": "Jalan Baru", 
        "kasirId": 2
      });
      expect(newToko, isNotNull);
      expect(newToko!.namaToko, "Toko Baru");
    });

    // TC-20
    test('TC-20: Update Toko returns updated object', () async {
       final updated = await tokoService.updateToko(10, {"namaToko": "Updated", "alamat": "Alamat", "kasirId": 2});
       expect(updated, isNotNull);
    });

    // TC-21
    test('TC-21: Delete Toko valid returns true', () async {
      final success = await tokoService.deleteToko(5); 
      expect(success, true);
    });

    // TC-22
    test('TC-22: Delete Toko invalid returns false (404)', () async {
      final success = await tokoService.deleteToko(99); 
      expect(success, false);
    });

    // TC-23
    test('TC-23: Get Toko Kasir/Admin returns list', () async {
      final list = await tokoService.getTokoList();
      expect(list, isNotEmpty);
      expect(list.first.namaToko, "Toko Lama");
    });
  });
}
