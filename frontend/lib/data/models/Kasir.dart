class Kasir {
  final int? id;
  final String username;
  final String phone;
  final String role;

  // FIELD TOKO (optional karena tidak selalu ada)
  final int? tokoId;
  final String? namaToko;
  final String? alamatToko;

  Kasir({
    this.id,
    required this.username,
    required this.phone,
    required this.role,
    this.tokoId,
    this.namaToko,
    this.alamatToko,
  });

  // JSON dari endpoint /api/users TIDAK berisi info toko,
  // jadi biarkan hanya parse field user saja.
  factory Kasir.fromJson(Map<String, dynamic> json) {
    return Kasir(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      role: json['role'],

      // info toko akan di-inject oleh KasirController
      tokoId: json['tokoId'],
      namaToko: json['namaToko'],
      alamatToko: json['alamatToko'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "phone": phone,
      "role": role,

      "tokoId": tokoId,
      "namaToko": namaToko,
      "alamatToko": alamatToko,
    };
  }
}
