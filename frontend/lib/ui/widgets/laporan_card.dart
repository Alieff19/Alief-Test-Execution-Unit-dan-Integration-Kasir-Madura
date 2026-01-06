import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import '../../data/models/laporan_transaksi.dart';

class LaporanCard extends StatelessWidget {
  final LaporanResponseModel transaksi;

  const LaporanCard({
    Key? key,
    required this.transaksi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hitung total produk terjual
    final totalProduk = transaksi.produkTerjual.fold<int>(
      0, (sum, item) => sum + item.jumlah,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER TOKO & KASIR ---
          Row(
            children: [
              Icon(
                Icons.store_rounded,
                color: AppTheme.primaryRed,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  transaksi.namaToko == '-' ? 'ADMIN' : transaksi.namaToko,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (transaksi.namaToko != '-' && transaksi.namaKasir.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                "Kasir: ${transaksi.namaKasir}",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSubtle,
                ),
              ),
            ),

          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 12),

          // --- LIST PRODUK ---
          ...transaksi.produkTerjual.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.namaProduk,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${item.jumlah}x Rp${item.hargaSatuan.toInt()}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSubtle,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 12),

          // --- TOTAL PRODUK TERJUAL & TOTAL TRANSAKSI ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Produk: $totalProduk",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSubtle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                "Rp${transaksi.totalPenjualan.toInt()}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
