class VerifyOtpResponse {
  final bool success;
  final String? message;

  VerifyOtpResponse({required this.success, this.message});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}
