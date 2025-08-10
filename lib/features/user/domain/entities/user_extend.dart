import 'package:pulse_chat/features/user/domain/entities/user.dart';

class Relationship {
  int contactId = -1;
  int contactStatus = -1;
  bool isSentRequest = false;

  Relationship({
    required this.contactId,
    required this.contactStatus,
    required this.isSentRequest,
  });
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
}
