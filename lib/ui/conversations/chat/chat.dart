import 'dart:convert';

import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/ui/conversations/chat/chat_websocket.dart';
import 'package:chatting_app/ui/view_models/chat_view_model.dart';
import 'package:chatting_app/ui/view_models/conversations_view_model.dart';
import 'package:chatting_app/ui/view_models/login_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget{
  final Conversation conversation;

  const ChatPage({super.key,required this.conversation});

  @override
  State<StatefulWidget> createState() => ChatPageState();
  
}

class ChatPageState extends State<ChatPage>{

  final ConversationsViewModel _conversationViewModel = ConversationsViewModel();
  final ChatViewModel _chatViewModel = ChatViewModel();
  final LoginViewModel _loginViewModel = LoginViewModel();

  late WebSocketChannel channel;

  late final Conversation _conversation;
  List<Message> _messages = [];
  int _userId = -1;
  final TextEditingController _messageContentController = TextEditingController();
  final ChatWebSocket _chatWebSocket = ChatWebSocket();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _conversationViewModel.requestGetConversationMessages(_conversation.id);
    _loginViewModel.requestCurrentUser();

    observeChange();
  }

  void observeChange(){
    _conversationViewModel.getConversationMessages().listen((data){
      setState(() {
          _messages.addAll(data); 
      });
    });
    _loginViewModel.getCurrentUser().listen((data) async{
      setState((){
        _userId = data.id;
      });
      await _chatWebSocket.init(_conversation.id, _userId);
      _chatWebSocket.messageStream.listen((data){
        Map<String, dynamic> jsonMessageOut = jsonDecode(data);
        Message messageOut = Message.fromJson(jsonMessageOut);
        setState(() {
          _messages.add(messageOut);
        });
        // Scroll to end after the new message is added
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_sharp)),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(_conversation.avatar),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(_conversation.subject, textAlign: TextAlign.start,),
                        Text("online"),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[600], thickness:  1,),
              _getChatBox(),
              Divider(color: Colors.grey[600], thickness:  1,),
              Row(
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                      child: CupertinoTextField(
                       placeholder: "Aa",
                       controller: _messageContentController,
                       padding: EdgeInsets.all(10),
                       style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                       ),
                       placeholderStyle: TextStyle(
                        color: Colors.grey
                       ),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send, color: Colors.green,), onPressed: sendMessage,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getDynamicColor(bool isDarkMode){
    return  isDarkMode ? Colors.white : Colors.black;
  }

  Widget _getChatBox() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index){
          // return ListTile(title : Text(_messages[index].content));
          return MessageBox(message: _messages[index], userId: _userId);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void sendMessage(){
    _chatViewModel.sendMessage(_userId, _conversation.id, _messageContentController.text);
    _messageContentController.text="";
  }
}
class MessageBox extends StatefulWidget{
  final Message message;
  final int userId;

  const MessageBox({super.key, required this.message, required this.userId});

  @override
  State<StatefulWidget> createState() => MessageBoxState();
}

class MessageBoxState extends State<MessageBox>{
  
  late Message message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return message.userId == widget.userId ? getOwnMessageBox(isDarkMode) : getOtherMessageBox(isDarkMode);
  }

  Widget getOwnMessageBox(bool isDarkMode){
    return ListTile( 
      title: Container(
        margin: EdgeInsets.only(left: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, const Color.fromRGBO(67, 160, 71, 1)]),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50) , 
            topLeft: Radius.circular(50), 
            bottomLeft:Radius.circular(50)
          )
        ),
        padding: EdgeInsets.all(15.0),
        child: Text(message.content),
      ),  
    );
  }

  Widget getOtherMessageBox(bool isDarkMode){
    return ListTile(
      leading: 
        SizedBox(
          width: 32,
          height: 32,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              message.avatar, 
              errorBuilder: (context, error, stackTrace) 
                => Image.network("https://api.dicebear.com/9.x/initials/png?seed=${message.name}&backgroundType=gradientLinear")
            ),
          ),
        ), 
      title: Container(
        margin: EdgeInsets.only(right: 50),
        decoration: BoxDecoration(
          color: getMessageBoxColor(isDarkMode),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50) , 
            topLeft: Radius.circular(50), 
            bottomRight:Radius.circular(50)
          )
        ),
        padding: EdgeInsets.all(15.0),
        child: Text(message.content, style: TextStyle(color: getMessageBoxTextColor(isDarkMode)),),
      ),  
    );
  }

  Color getMessageBoxColor(bool isDarkMode){
    return isDarkMode ? Color.fromRGBO(35, 36, 37, 1) : Color.fromRGBO(189, 189, 189, 1);
  }

  Color getMessageBoxTextColor(bool isDarkMode){
    return isDarkMode ? Color.fromRGBO(189, 189, 189, 1) : Color.fromRGBO(35, 36, 37, 1);
  }

}

