import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';

class CardKasirToko extends StatelessWidget {
  final String namaKasir;
  final String phone;
  final String namaToko;
  final String alamatToko;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CardKasirToko({
    super.key,
    required this.namaKasir,
    required this.phone,
    required this.namaToko,
    required this.alamatToko,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryCream,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.border),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.shadowLight,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nama Kasir : $namaKasir",
            style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Text(
            "Phone: $phone",
            style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Text(
            "Nama Toko : $namaToko",
            style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Text(
            "Alamat Toko : $alamatToko",
            style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDelete != null)
                _hapusButton(context),

              if (onDelete != null && onEdit != null)
                const SizedBox(width: 12),

              if (onEdit != null)
                _editButton(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _hapusButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onDelete,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.delete, size: 18, color: Colors.white),
      label: Text(
        "Hapus",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onEdit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.edit, size: 18, color: Colors.white),
      label: Text(
        "Edit",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
