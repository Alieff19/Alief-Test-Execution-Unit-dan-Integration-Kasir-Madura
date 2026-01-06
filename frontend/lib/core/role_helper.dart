import 'package:shared_preferences/shared_preferences.dart';

/// Helper class untuk role-based access control
/// Mengambil role dari SharedPreferences yang disimpan saat login
class RoleHelper {
  // Role constants
  static const String ADMIN = 'ADMIN';
  static const String KASIR = 'KASIR';

  /// Get current user role from SharedPreferences
  static Future<String?> getRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('role');
    } catch (e) {
      print('Error getting role: $e');
      return null;
    }
  }

  /// Check if current user is ADMIN
  static Future<bool> isAdmin() async {
    final role = await getRole();
    return role == ADMIN;
  }

  /// Check if current user is KASIR
  static Future<bool> isKasir() async {
    final role = await getRole();
    return role == KASIR;
  }

  /// Check if user can access specific feature
  /// 
  /// Features:
  /// - checkout: ADMIN ✅, KASIR ✅
  /// - edit_produk: ADMIN ✅, KASIR ✅
  /// - laporan_penjualan: ADMIN ✅, KASIR ❌
  /// - tambah_toko: ADMIN ✅, KASIR ❌
  /// - tambah_pengguna: ADMIN ✅, KASIR ❌
  /// - manajemen_user: ADMIN ✅, KASIR ❌
  static Future<bool> canAccessFeature(String feature) async {
    final role = await getRole();
    
    if (role == ADMIN) {
      return true; // Admin can access everything
    }
    
    // Kasir only can access these features
    final kasirFeatures = [
      'checkout',
      'edit_produk',
      'dashboard',
      'produk',
    ];
    
    return kasirFeatures.contains(feature);
  }

  /// Get user-friendly role name
  static Future<String> getRoleName() async {
    final role = await getRole();
    switch (role) {
      case ADMIN:
        return 'Administrator';
      case KASIR:
        return 'Kasir';
      default:
        return 'Unknown';
    }
  }

  /// Check if feature is admin-only
  static bool isAdminOnlyFeature(String feature) {
    final adminOnlyFeatures = [
      'laporan_penjualan',
      'tambah_toko',
      'tambah_pengguna',
      'manajemen_user',
    ];
    
    return adminOnlyFeatures.contains(feature);
  }
}
