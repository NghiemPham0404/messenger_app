class GoogleLogin {
  final String email;
  final String username;
  final String avatar;
  final String provider = "google";
  final String providerId;

  GoogleLogin({
    required this.email,
    required this.username,
    required this.avatar,
    required this.providerId,
  });
}
