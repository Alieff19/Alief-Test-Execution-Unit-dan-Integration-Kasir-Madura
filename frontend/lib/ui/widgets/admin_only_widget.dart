import 'package:flutter/material.dart';
import '../../core/role_helper.dart';

/// Widget wrapper untuk menampilkan konten hanya untuk ADMIN
/// Kasir tidak akan melihat widget ini sama sekali
/// 
/// Usage:
/// ```dart
/// AdminOnlyWidget(
///   child: ListTile(
///     title: Text('Laporan Penjualan'),
///     onTap: () => Navigator.push(...),
///   ),
/// )
/// ```
class AdminOnlyWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback; // Optional: widget untuk ditampilkan ke non-admin

  const AdminOnlyWidget({
    Key? key,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: RoleHelper.isAdmin(),
      builder: (context, snapshot) {
        // Saat loading, tidak tampilkan apa-apa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        // Jika ADMIN, tampilkan child
        if (snapshot.data == true) {
          return child;
        }

        // Jika bukan ADMIN, tampilkan fallback atau hide
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

/// Widget wrapper untuk feature-based access control
/// Lebih flexible dari AdminOnlyWidget
/// 
/// Usage:
/// ```dart
/// RoleGuardWidget(
///   feature: 'laporan_penjualan',
///   child: ListTile(...),
///   deniedChild: ListTile(..., enabled: false), // optional
/// )
/// ```
class RoleGuardWidget extends StatelessWidget {
  final String feature;
  final Widget child;
  final Widget? deniedChild; // Widget jika akses ditolak
  final VoidCallback? onAccessDenied; // Callback jika akses ditolak

  const RoleGuardWidget({
    Key? key,
    required this.feature,
    required this.child,
    this.deniedChild,
    this.onAccessDenied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: RoleHelper.canAccessFeature(feature),
      builder: (context, snapshot) {
        // Saat loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        // Jika bisa akses
        if (snapshot.data == true) {
          return child;
        }

        // Jika tidak bisa akses
        if (onAccessDenied != null) {
          onAccessDenied!();
        }

        return deniedChild ?? const SizedBox.shrink();
      },
    );
  }
}

/// Helper function untuk navigation guard
/// Digunakan sebelum Navigator.push() untuk cek role
/// 
/// Usage:
/// ```dart
/// onTap: () async {
///   final allowed = await checkRoleBeforeNavigate(
///     context,
///     feature: 'laporan_penjualan',
///     adminOnly: true,
///   );
///   
///   if (allowed) {
///     Navigator.push(context, LaporanPenjualanPage());
///   }
/// }
/// ```
Future<bool> checkRoleBeforeNavigate(
  BuildContext context, {
  String? feature,
  bool adminOnly = false,
}) async {
  if (adminOnly) {
    final isAdmin = await RoleHelper.isAdmin();
    if (!isAdmin) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akses ditolak. Fitur ini khusus untuk Admin.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return false;
    }
    return true;
  }

  if (feature != null) {
    final canAccess = await RoleHelper.canAccessFeature(feature);
    if (!canAccess) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akses ditolak. Anda tidak memiliki izin untuk fitur ini.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return false;
    }
    return true;
  }

  return true;
}
