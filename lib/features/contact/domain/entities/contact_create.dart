class ContactCreate {
  int userId;
  int contactUserId;
  int status;

  ContactCreate({
    required this.userId,
    required this.contactUserId,
    required this.status,
  });
}
