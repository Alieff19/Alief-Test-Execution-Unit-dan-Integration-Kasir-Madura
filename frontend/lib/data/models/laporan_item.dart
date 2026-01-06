class LaporanItem {
  final String namaProduk;
  final int jumlah;
  final double hargaSatuan;
  final double total;

  LaporanItem({
    required this.namaProduk,
    required this.jumlah,
    required this.hargaSatuan,
    required this.total,
  });

  factory LaporanItem.fromJson(Map<String, dynamic> json) {
    return LaporanItem(
      namaProduk: json['namaProduk'] ?? '',
      jumlah: (json['jumlah'] ?? 0) as int,
      hargaSatuan: (json['hargaSatuan'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
