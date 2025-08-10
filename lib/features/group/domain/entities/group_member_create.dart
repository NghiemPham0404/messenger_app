class GroupMemberSelection {
  int id;
  String? avatar;

  GroupMemberSelection({required this.id, this.avatar});
}

class GroupMemberCreate {
  int userId;

  int groupId;

  bool isHost;

  int status;

  GroupMemberCreate({
    required this.userId,
    required this.groupId,
    required this.isHost,
    required this.status,
  });
}
