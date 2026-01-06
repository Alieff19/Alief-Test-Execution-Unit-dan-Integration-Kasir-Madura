class LoginResponse {
  final String? token;
  final String? role;
  final String message;
  final int? tokoId;

  LoginResponse({
    required this.token,
    required this.role,
    required this.message,
    this.tokoId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      role: json['role'],
      message: json['message'] ?? '',
      tokoId: json['tokoId'] != null ? int.tryParse(json['tokoId'].toString()) : null,
    );
  }
}
