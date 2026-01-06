import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../state/kasir_controller.dart';
import '../widgets/card_kasir_toko.dart';
import 'popupTambahToko.dart';
import '../widgets/notif_popup.dart';
import '../../state/toko_controller.dart';
import '../../core/role_helper.dart';


class TambahTokoPage extends StatefulWidget {
  const TambahTokoPage({super.key});

  @override
  State<TambahTokoPage> createState() => _TambahTokoPageState();
}

class _TambahTokoPageState extends State<TambahTokoPage> {
  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  // Role validation saat page dibuka
  Future<void> _checkAccess() async {
    final isAdmin = await RoleHelper.isAdmin();
    if (!isAdmin && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akses ditolak. Halaman ini khusus untuk Admin.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _TambahTokoView();
  }
}

// ============================================================
// VIEW UTAMA (UI TIDAK DIUBAH PADA APPBAR & STYLE)
// ============================================================
class _TambahTokoView extends StatelessWidget {
  const _TambahTokoView({super.key});

  @override
  Widget build(BuildContext context) {
    final kasirC = Provider.of<KasirController>(context);
    final parentContext = context;

    return Scaffold(
      backgroundColor: AppTheme.primaryCream,

      // =================== APPBAR (SAMA SEPERTI SEBELUMNYA) ===================
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
                          Icons.store_mall_directory_outlined,
                          color: AppTheme.primaryCream,
                          size: 30,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tambah Toko',
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryCream,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
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

      // =================== BODY: LIST KASIR ===================
      body: SafeArea(
        child: kasirC.loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () async {
            await kasirC.load();
          },
          color: AppTheme.primaryRed,
          backgroundColor: AppTheme.primaryCream,
          child: ListView.builder(
            padding:
            const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 40),
            itemCount: kasirC.items.length,
            itemBuilder: (context, i) {
              final k = kasirC.items[i];

            // hanya tampilkan user dengan role KASIR
            if (k.role != "KASIR") return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CardKasirToko(
                namaKasir: k.username ?? '-',
                phone: k.phone ?? '-',
                namaToko: k.namaToko ?? '-',
                alamatToko: k.alamatToko ?? '-',

                // nanti tombol Edit dihubungkan ke tambah/update toko
                onEdit: () {
                    // ✔ context aman disimpan di sini

                  showDialog(
                    context: parentContext,
                    builder: (ctx) => PopupTambahToko(
                      initialNama: k.namaToko ?? "",
                      initialAlamat: k.alamatToko ?? "",
                      onSave: (nama, alamat) async {
                        Navigator.pop(ctx);

                        final tokoC = TokoController.http();

                        // INSERT
                        if (k.tokoId == null) {
                          await tokoC.tambahToko(
                            namaToko: nama,
                            alamat: alamat,
                            kasirId: k.id!,
                          );
                        } else {
                          // UPDATE
                          await tokoC.updateToko(
                            tokoId: k.tokoId!,
                            namaToko: nama,
                            alamat: alamat,
                            kasirId: k.id!,
                          );
                        }

                        // reload data
                        await Provider.of<KasirController>(parentContext, listen: false).load();

                        // gunakan parentContext (TIDAK BISA pakai context lama)
                        showDialog(
                          context: parentContext,
                          barrierColor: Colors.transparent, // <— FIX PALING PENTING
                          builder: (_) => NotifPopup.success(
                            parentContext,
                            k.tokoId == null
                                ? "Toko berhasil ditambahkan"
                                : "Toko berhasil diperbarui",
                          ),
                        );
                      },
                    ),
                  );
                },
                onDelete: null,
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}
