import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_routes.dart';
import '../../core/role_helper.dart';




/// Panggil ini dari tombol hamburger:
/// await showHamburgerMenu(context, onLaporan: ..., onTambahToko: ..., onEditProduk: ..., onLogout: ...);
Future<void> showHamburgerMenu(
    BuildContext context, {
      VoidCallback? onLaporan,
      VoidCallback? onTambahToko,
      VoidCallback? onEditProduk,
      VoidCallback? onTambahPengguna,
      VoidCallback? onLogout,
    }) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Menu',
    barrierColor: Colors.black54, // backdrop
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, _, __) {
      // kosong — UI dibangun di transitionBuilder
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, anim, _, __) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      final slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(curved);

      final panelWidth = math.min(MediaQuery.of(context).size.width * 0.82, 320.0);

      return Stack(
        children: [
          // Dismiss area
          Positioned.fill(
            child: GestureDetector(onTap: () => Navigator.of(context).pop()),
          ),
          // Panel geser dari kiri
          Align(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: slide,
              child: _HamburgerPanel(
                width: panelWidth,
                onLaporan: onLaporan,
                onTambahToko: () {
                  Navigator.of(context).pop(); // tutup menu
                  Navigator.pushNamed(context, AppRoutes.tambahToko);
                },
                onEditProduk: onEditProduk,
                onTambahPengguna: onTambahPengguna,
                onLogout: onLogout,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _HamburgerPanel extends StatelessWidget {
  final double width;
  final VoidCallback? onLaporan;
  final VoidCallback? onTambahToko;
  final VoidCallback? onEditProduk;
  final VoidCallback? onTambahPengguna;
  final VoidCallback? onLogout;

  const _HamburgerPanel({
    required this.width,
    this.onLaporan,
    this.onTambahToko,
    this.onEditProduk,
    this.onTambahPengguna,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: width,
      // hilangkan margin kiri, biar nempel ke tepi
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias, // agar isi ter-clip radius kanan
      decoration: const BoxDecoration(
        color: AppTheme.primaryCream,
        // radius kanan saja
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header gradient (radius kanan saja)
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(21),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    'assets/images/logo3.png',
                    fit: BoxFit.contain,
                  ),
                ),
                // Text
                Text(
                  'Madura Store',
                  style: t.titleLarge?.copyWith(
                    color: AppTheme.primaryWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // Menu item (with role-based disable)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Laporan penjualan - Admin only
                _RoleBasedMenuButton(
                  label: 'Laporan penjualan',
                  icon: Icons.bar_chart_rounded,
                  onTap: onLaporan,
                  adminOnly: true,
                ),
                const SizedBox(height: 16),
                // Tambah toko - Admin only
                _RoleBasedMenuButton(
                  label: 'Tambah toko',
                  icon: Icons.store_mall_directory_outlined,
                  onTap: onTambahToko,
                  adminOnly: true,
                ),
                const SizedBox(height: 16),
                // Edit produk - Available for both ADMIN & KASIR
                _RoleBasedMenuButton(
                  label: 'Edit produk',
                  icon: Icons.edit_outlined,
                  onTap: onEditProduk,
                  adminOnly: false,
                ),
                const SizedBox(height: 16),
                // Tambah pengguna - Admin only
                _RoleBasedMenuButton(
                  label: 'Tambah pengguna',
                  icon: Icons.person_add_rounded,
                  onTap: onTambahPengguna,
                  adminOnly: true,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Tombol logout
      Padding(
        // gunakan bottom inset supaya tidak ketutup gesture bar
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          100,
          math.max(24, MediaQuery.of(context).padding.bottom + 16),
        ),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onLogout,
            icon: Transform.rotate(
              angle: 3.1416, // 180 derajat (π radian)
              child: const Icon(Icons.logout_rounded),
            ),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: AppTheme.primaryWhite,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  topRight: Radius.circular(0),   // 👈 kanan 0
                  bottomRight: Radius.circular(50), // 👈 kanan bawah besar (setengah lingkaran)
                ),
              ),
              textStyle: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
         ),
        ],
      ),
    );

  }
}

// Role-based menu button wrapper
class _RoleBasedMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool adminOnly;

  const _RoleBasedMenuButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.adminOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: RoleHelper.isAdmin(),
      builder: (context, snapshot) {
        // Saat loading, tampilkan disabled
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _OutlineMenuButton(
            label: label,
            icon: icon,
            onTap: null,
            enabled: false,
          );
        }

        final isAdmin = snapshot.data ?? false;
        final isEnabled = !adminOnly || isAdmin;

        return _OutlineMenuButton(
          label: label,
          icon: icon,
          onTap: isEnabled ? onTap : null,
          enabled: isEnabled,
        );
      },
    );
  }
}

class _OutlineMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _OutlineMenuButton({
    required this.label,
    required this.icon,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isDisabled = !enabled || onTap == null;

    return Material(
      color: isDisabled ? Colors.grey.shade400 : AppTheme.primaryOrange,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isDisabled ? null : onTap,
        splashColor: isDisabled ? Colors.transparent : AppTheme.primaryRed,
        highlightColor: isDisabled ? Colors.transparent : AppTheme.primaryRed,
        child: Container(
          height: 44,
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade400 : AppTheme.primaryOrange,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 17),
              Icon(
                icon,
                color: isDisabled ? Colors.grey.shade600 : AppTheme.primaryCream,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleMedium?.copyWith(
                    fontSize: 16,
                    color: isDisabled ? Colors.grey.shade600 : AppTheme.primaryCream,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
