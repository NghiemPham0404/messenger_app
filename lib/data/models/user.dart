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

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatar:
          map['avatar'] ??
          "https://api.dicebear.com/9.x/initials/svg?seed=${map['name']}&backgoundType=gradientLinear",
    );
  }
}

class Relationship {
  int contactId = -1;
  int contactStatus = -1;
  bool isSentRequest = false;

  Relationship({
    required this.contactId,
    required this.contactStatus,
    required this.isSentRequest,
  });

  factory Relationship.fromJson(Map<String, dynamic> map) {
    return Relationship(
      contactId: map['contact_id'],
      contactStatus: map['contact_status'],
      isSentRequest: map['is_sent_request'],
    );
  }
}

class UserExtended extends User {
  Relationship relationship;

  UserExtended({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    required this.relationship,
  });

  factory UserExtended.fromJson(Map<String, dynamic> map) {
    return UserExtended(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatar:
          map['avatar'] ??
          "https://api.dicebear.com/9.x/initials/svg?seed=${map['name']}&backgoundType=gradientLinear",
      relationship: Relationship.fromJson(map['relationship']),
    );
  }
}
