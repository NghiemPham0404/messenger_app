class Contact {
  int id;
  int userId;
  int contactUserId;
  int status;
  OtherUser otherUser;

  Contact({
    required this.id,
    required this.userId,
    required this.contactUserId,
    required this.status,
    required this.otherUser,
  });
}

class OtherUser {
  int id;
  String name;
  String? avatar;

  OtherUser({required this.id, required this.name, this.avatar});
}
