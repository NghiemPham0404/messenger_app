import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/ui/conversations/chat/chat.dart';
import 'package:chatting_app/ui/view_models/conversations_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationsTab extends StatelessWidget{
  const ConversationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : const ConversationsPage()
      ),
    );
  }
  
}

class ConversationsPage extends StatefulWidget{

  const ConversationsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ConversationsPageState();
  }
  
}

class ConversationsPageState extends State<ConversationsPage>{
  late final ConversationsViewModel _conversationViewModel;
  List<Conversation> _conversations = [];

  @override
  void initState(){
    super.initState();
    _conversationViewModel = ConversationsViewModel();
    _conversationViewModel.requestGetConversationsOfUser();
    observeChange();
  }

  void observeChange(){
    _conversationViewModel.getUserConversations().listen((data){
      setState(() {
        _conversations = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;  

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            _getHeader(isDarkMode),
            Divider(thickness: 1,),
            Expanded(
              child: _getConversationList()
            ),
          ],
        ),
      ),
    );
  }
  Widget _getHeader(bool isDarkMode){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Expanded(
            child: CupertinoTextField(
              placeholder: 'chat, person, groups...',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(CupertinoIcons.qrcode_viewfinder, color: Theme.of(context).primaryColor),
            onPressed: () {
              // Handle QR scan
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(CupertinoIcons.add_circled, color: Theme.of(context).primaryColor),
            onPressed: () {
              // Handle Add Group
            },
          ),
        ],
      ),
    );
  }

  Widget _getConversationList(){
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) =>
        _getConversationRow(index),
    );
  }

  ListTile _getConversationRow(int index){
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          _conversations[index].avatar, 
            errorBuilder: (context, error, stackTrace){
            return CircleAvatar(
              child: Text(_conversations[index].subject[0]),
            );
            },
        ),
      ),
      title: Text(_conversations[index].subject),
      onTap: () => _navigateToChatView(index),
    );
  }

  void _navigateToChatView(int index){
    Navigator.push(context, 
      CupertinoPageRoute(
        builder: (context)=>  ChatPage(
          conversation: _conversations[index]
        )
      )
    );
  }
}