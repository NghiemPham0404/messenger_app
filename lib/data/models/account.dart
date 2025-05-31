class UserOut{
  int id;
  String name;
  String email;
  String ?avatar;

  UserOut(
    {
      required this.id, 
      required this.name, 
      required this.email,
      this.avatar
    }
  );

  factory UserOut.fromJson(Map<String, dynamic> map){
      return UserOut(
          id : map['id'],
          name : map['name'],
          email : map['email'],
          avatar: map['avatar']?? "https://api.dicebear.com/9.x/initials/svg?seed=${map['name']}&backgoundType=gradientLinear",
      );
  }
}
