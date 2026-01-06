class Transaksi {
  final int? id;
  final double pembayaran;
  final double totalBayar;
  final double kembalian;
  final String? tanggal;
  final List<ItemTransaksi> items;

  Transaksi({
    this.id,
    required this.pembayaran,
    required this.totalBayar,
    required this.kembalian,
    this.tanggal,
    required this.items,
  });

  // Convert dari JSON (response backend)
  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      pembayaran: json['pembayaran'].toDouble(),
      totalBayar: json['totalBayar'].toDouble(),
      kembalian: json['kembalian'].toDouble(),
      tanggal: json['tanggal'],
      items: (json['items'] as List)
          .map((item) => ItemTransaksi.fromJson(item))
          .toList(),
    );
  }

  // Convert ke JSON (kirim ke backend)
  Map<String, dynamic> toJson() {
    return {
      'pembayaran': pembayaran,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ItemTransaksi {
  final int produkId;
  final String? namaProduk;
  final int jumlah;
  final double? harga;

  ItemTransaksi({
    required this.produkId,
    this.namaProduk,
    required this.jumlah,
    this.harga,
  });

  factory ItemTransaksi.fromJson(Map<String, dynamic> json) {
    return ItemTransaksi(
      produkId: json['produkId'],
      namaProduk: json['namaProduk'],
      jumlah: json['jumlah'],
      harga: json['harga']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produkId': produkId,
      'jumlah': jumlah,
    };
  }
}