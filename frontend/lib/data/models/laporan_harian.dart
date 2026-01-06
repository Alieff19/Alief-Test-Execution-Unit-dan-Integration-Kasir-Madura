import 'laporan_transaksi.dart';

class DailyReport {
  final String tanggal;
  final double totalHarian;
  final List<LaporanResponseModel> transaksi;

  DailyReport({
    required this.tanggal,
    required this.totalHarian,
    required this.transaksi,
  });

  factory DailyReport.fromJson(Map<String, dynamic> json) {
    final transaksiJson = json['transaksi'] as List<dynamic>? ?? [];
    final transaksi = transaksiJson
        .map((e) => LaporanResponseModel.fromJson(e))
        .toList();

    return DailyReport(
      tanggal: json['tanggal'] ?? '',
      totalHarian: (json['totalHarian'] ?? 0).toDouble(),
      transaksi: transaksi,
    );
  }
}
