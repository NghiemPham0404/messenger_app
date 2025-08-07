class FcmTokenCreate {
  final String token;
  final int userId;
  final DateTime updatedAt;

  FcmTokenCreate({
    required this.token,
    required this.userId,
    required this.updatedAt,
  });
}
