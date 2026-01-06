import 'laporan_item.dart';

class LaporanResponseModel {
  final String tanggal;
  final String namaToko;
  final String namaKasir;
  final List<LaporanItem> produkTerjual;
  final double totalPenjualan;

  LaporanResponseModel({
    required this.tanggal,
    required this.namaToko,
    required this.namaKasir,
    required this.produkTerjual,
    required this.totalPenjualan,
  });

  factory LaporanResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['produkTerjual'] as List<dynamic>? ?? [];
    final List<LaporanItem> items = itemsJson.map((e) {
      return LaporanItem.fromJson(Map<String, dynamic>.from(e));
    }).toList();

    return LaporanResponseModel(
      tanggal: json['tanggal'] ?? '',
      namaToko: json['namaToko'] ?? '',
      namaKasir: json['namaKasir'] ?? '',
      produkTerjual: items,
      totalPenjualan: (json['totalPenjualan'] ?? 0).toDouble(),
    );
  }
}
