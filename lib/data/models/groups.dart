class Group {
  int? id;
  String? subject;
  String? avatar;
  bool? isPublic;
  bool? isMemberMute;

  Group({this.id, this.subject, this.avatar, this.isPublic, this.isMemberMute});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    avatar = json['avatar'];
    isPublic = json['is_public'];
    isMemberMute = json['is_member_mute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['avatar'] = this.avatar;
    data['is_public'] = this.isPublic;
    data['is_member_mute'] = this.isMemberMute;
    return data;
  }
}
