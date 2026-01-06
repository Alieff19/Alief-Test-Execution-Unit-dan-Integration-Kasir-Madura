class Toko {
  final int? id;
  final String namaToko;
  final String alamat;

  // data kasir (user) yang dimiliki toko
  final int? kasirId;
  final String? kasirNama;
  final String? kasirPhone;
  final String? kasirRole;

  Toko({
    this.id,
    required this.namaToko,
    required this.alamat,
    this.kasirId,
    this.kasirNama,
    this.kasirPhone,
    this.kasirRole,
  });

  // ==========================================================
  // PARSE JSON dari backend
  // Backend return:
  //
  // {
  //   "id": 4,
  //   "namaToko": "madura 1",
  //   "alamat": "surabaya",
  //   "kasir": {
  //     "id": 31,
  //     "username": "chel",
  //     "phone": "0851233445",
  //     "role": "KASIR"
  //   }
  // }
  // ==========================================================
  factory Toko.fromJson(Map<String, dynamic> json) {
    final kasir = json["kasir"]; // bisa null

    return Toko(
      id: json["id"],
      namaToko: json["namaToko"] ?? "",
      alamat: json["alamat"] ?? "",
      kasirId: kasir?["id"],
      kasirNama: kasir?["username"],
      kasirPhone: kasir?["phone"],
      kasirRole: kasir?["role"],
    );
  }

  // ==========================================================
  // JSON UNTUK POST /api/toko/add
  // backend butuh:
  // { "namaToko": "...", "alamat": "...", "kasirId": 31 }
  // ==========================================================
  Map<String, dynamic> toAddJson() {
    return {
      "namaToko": namaToko,
      "alamat": alamat,
      "kasirId": kasirId,
    };
  }

  // ==========================================================
  // JSON UNTUK PUT /api/toko/{id}
  // backend update field yang dikirim
  // ==========================================================
  Map<String, dynamic> toUpdateJson() {
    return {
      "namaToko": namaToko,
      "alamat": alamat,
      "kasirId": kasirId, // kamu butuh kirim kasirId juga
    };
  }
}
