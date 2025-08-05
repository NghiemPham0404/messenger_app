class AuthResponse {
  String accessToken;
  String refreshToken;
  String bearerType;

  AuthResponse({
    required this.accessToken,
    required this.bearerType,
    required this.refreshToken,
  });
}
