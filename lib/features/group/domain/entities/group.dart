class Group {
  int id;
  String subject;
  String? avatar;

  bool isPublic;

  bool isMemberMute;

  int? membersCount = 0;

  Group({
    required this.id,
    required this.subject,
    required this.avatar,
    required this.isPublic,
    required this.isMemberMute,
    this.membersCount,
  });
}
