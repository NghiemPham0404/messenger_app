// class MessageOut(MessageBase):
//     id : Optional[int] = None
//     conversation_id : Optional[int] = None 
//     name: Optional[str] = None
//     avatar: Optional[str] = None 
//     content: Optional[str] = None
//     timestamp: Optional[datetime.datetime]
//     model_config = ConfigDict(from_attributes=True)
//     cp_id: int = None

class Message{
  int id;
  String content;
  DateTime timestamp;

  int userId;
  String name;
  String avatar;

  Message(
    {
      required this.id,
      required this.content,
      required this.timestamp,

      required this.userId,
      required this.name,
      required this.avatar, 
    }
  );

  factory Message.fromJson(Map<String, dynamic> map){
    return Message(
      id : map['id'],
      content : map['content'] ?? "deleted message",
      timestamp : DateTime.parse(map['timestamp']),

      userId : map['user_id'],
      name : map['name'],
      avatar : map['avatar'] ?? "https://api.dicebear.com/9.x/initials/png?seed=${map['name']}&backgroundType=gradientLinear"
    );
  }
}