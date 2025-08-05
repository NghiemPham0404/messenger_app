class User {
  int id;
  String name;
  String email;
  String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
}
