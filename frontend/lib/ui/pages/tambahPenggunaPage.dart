import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../state/kasir_controller.dart';
import '../widgets/notif_popup.dart';
import '../widgets/dialog_confirm.dart';
import 'TambahKasir.dart';
import '../widgets/card_kasir_toko.dart';
import '../../core/role_helper.dart';

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  late KasirController controller;
  bool _isCheckingAccess = true;

  @override
  void initState() {
    super.initState();
    // Initialize controller LANGSUNG (not inside async)
    controller = KasirController();
    // Baru check access
    _checkAccessAndLoad();
  }

  // Role validation saat page dibuka
  Future<void> _checkAccessAndLoad() async {
    final isAdmin = await RoleHelper.isAdmin();
    if (!isAdmin && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akses ditolak. Halaman ini khusus untuk Admin.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    // Load data setelah access check passed
    controller.load();
    if (mounted) {
      setState(() {
        _isCheckingAccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return ChangeNotifierProvider.value(
      value: controller,
      child: const _TambahPenggunaView(),
    );
  }
}

class _TambahPenggunaView extends StatelessWidget {
  const _TambahPenggunaView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<KasirController>();
    final parentContext = context; // Simpan context untuk notifikasi

    return Scaffold(
      backgroundColor: AppTheme.primaryCream,
      resizeToAvoidBottomInset: false,

      // =================== APPBAR ===================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.primaryCream,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: AppTheme.primaryCream,
                          size: 30,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tambah Pengguna',
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryCream,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: c.loading
          ? const Center(child: CircularProgressIndicator())
          : Builder(builder: (_) {
        final kasirOnly =
        c.items.where((u) => u.role == "KASIR").toList();

        return RefreshIndicator(
          onRefresh: () async {
            await c.load();
          },
          color: AppTheme.primaryRed,
          backgroundColor: AppTheme.primaryCream,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: kasirOnly.length,
            itemBuilder: (context, i) {
              final pengguna = kasirOnly[i];

            return CardKasirToko(
              namaKasir: pengguna.username ?? "-",
              phone: pengguna.phone ?? "-",
              namaToko: pengguna.namaToko ?? "-",
              alamatToko: pengguna.alamatToko ?? "-",

              // ========================= EDIT =========================
              onEdit: () {
                showDialog(
                  context: parentContext,
                  barrierDismissible: true,
                  builder: (dialogCtx) {
                    return TambahKasir(
                      initialNama: pengguna.username,
                      initialTelp: pengguna.phone,
                      initialPass: "",
                      onSave: (nama, telp, pass) async {
                        Navigator.of(dialogCtx).pop(); // Tutup dialog dulu

                        final ok = await c.updateKasir(
                          pengguna.id!,
                          nama,
                          telp,
                        );

                        // Reload data
                        await c.load();

                        // Tampilkan notifikasi
                        showDialog(
                          context: parentContext,
                          barrierColor: Colors.transparent,
                          builder: (_) => ok
                              ? NotifPopup.success(
                                  parentContext,
                                  "Kasir berhasil diperbarui",
                                )
                              : NotifPopup.error(
                                  parentContext,
                                  "Gagal memperbarui kasir",
                                ),
                        );
                      },
                    );
                  },
                );
              },

              // ========================= DELETE =========================
              onDelete: () async {
                final confirm = await showConfirmDialog(
                  context: parentContext,
                  icon: Icons.delete_outline_rounded,
                  message: 'Kasir dan toko akan dihapus. Lanjutkan?',
                  leftButtonText: 'Batal',
                  rightButtonText: 'Ya, hapus',
                  rightButtonColor: Color(0xFFB81313),
                );

                if (confirm != true) return;

                final ok = await c.deleteKasir(pengguna.id!);

                // Reload data
                await c.load();

                // Tampilkan notifikasi
                showDialog(
                  context: parentContext,
                  barrierColor: Colors.transparent,
                  builder: (_) => ok
                      ? NotifPopup.success(
                          parentContext,
                          "Pengguna dan toko berhasil dihapus",
                        )
                      : NotifPopup.error(
                          parentContext,
                          "Gagal menghapus pengguna",
                        ),
                );
              },
            );
          },
        ),
        );
      }),

      // ===================== BOTTOM BUTTON =====================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(45, 8, 45, 20),
        decoration: const BoxDecoration(color: AppTheme.primaryCream),
        child: SizedBox(
          height: 55,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: parentContext,
                  barrierDismissible: true,
                  builder: (dialogCtx) {
                    return TambahKasir(
                      onSave: (nama, telp, pass) async {
                        Navigator.of(dialogCtx).pop(); // Tutup dialog dulu

                        final ok = await c.tambahKasir(nama, telp, pass);

                        // Reload data
                        await c.load();

                        // Tampilkan notifikasi
                        showDialog(
                          context: parentContext,
                          barrierColor: Colors.transparent,
                          builder: (_) => ok
                              ? NotifPopup.success(
                                  parentContext,
                                  "Kasir berhasil disimpan",
                                )
                              : NotifPopup.error(
                                  parentContext,
                                  "Gagal menyimpan kasir",
                                ),
                        );
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Tambah Kasir',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
