class GroupMember {
  int userId;

  int groupId;

  int id;
  bool isHost;

  bool isSubHost;
  int status;
  GroupMemberInfo? member;

  GroupMember({
    required this.userId,
    required this.groupId,
    required this.id,
    required this.isHost,
    required this.isSubHost,
    required this.status,
    this.member,
  });
}

class GroupMemberInfo {
  int? id;
  String? name;
  String? avatar;

  GroupMemberInfo({this.id, this.name, this.avatar});
}
