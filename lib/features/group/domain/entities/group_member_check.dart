class GroupMemberCheck {
  int userId;

  bool isHost;

  bool isSubHost;

  int? groupMemberId;

  int status;

  GroupMemberCheck({
    this.groupMemberId,
    required this.userId,
    required this.isHost,
    required this.isSubHost,
    required this.status,
  });
}
