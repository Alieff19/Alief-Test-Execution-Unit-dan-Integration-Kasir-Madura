class UserRequest {
  final String username;
  final String password;
  final String phone;

  UserRequest({required this.username, required this.password, required this.phone});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'phone': phone,
  };
}
