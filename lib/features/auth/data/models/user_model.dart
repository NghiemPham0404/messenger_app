import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatar:
          map['avatar'] ??
          "https://api.dicebear.com/9.x/initials/svg?seed=${map['name']}&backgoundType=gradientLinear",
    );
  }
}
