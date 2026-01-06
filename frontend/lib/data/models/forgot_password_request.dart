class ForgotPasswordRequest {
  final String phone;

  ForgotPasswordRequest({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};
}
