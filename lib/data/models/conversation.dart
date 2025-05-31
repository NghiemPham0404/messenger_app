class Conversation {
  int id;
  String subject;
  String avatar;

  Conversation(
    {
      required this.id, 
      required this.subject, 
      required this.avatar,
    }
  );

  factory Conversation.fromJson(Map<String, dynamic> map){
      return Conversation(
          id : map['id'],
          subject : map['subject'],
          avatar: map['avatar']?? "https://api.dicebear.com/9.x/initials/png?seed=${map['subject']}&backgroundType=gradientLinear",
      );
  }
}