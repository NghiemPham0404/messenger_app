class FcmToken {
  int id;
  String token;
  DateTime updatedAt;
  int userId;

  FcmToken({
    required this.id,
    required this.token,
    required this.updatedAt,
    required this.userId,
  });
}
