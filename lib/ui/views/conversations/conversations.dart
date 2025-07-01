import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/ui/view_models/chat_view_model.dart';
import 'package:chatting_app/ui/views/conversations/chat/chat.dart';
import 'package:chatting_app/ui/view_models/conversations_view_model.dart';
import 'package:chatting_app/ui/widgets/conversation/conversation_list.dart';
import 'package:chatting_app/ui/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationsTab extends StatelessWidget {
  const ConversationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: const ConversationsPage()));
  }
}

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ConversationsPageState();
  }
}

class ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationsViewModel>(
      builder:
          (context, viewModel, child) => CupertinoPageScaffold(
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(title: _getHeader()),
                body: Column(
                  children: [Expanded(child: _getConversationList(viewModel))],
                ),
              ),
            ),
          ),
    );
  }

  Widget _getHeader() {
    return SearchAppBar();
  }

  Widget _getConversationList(ConversationsViewModel viewModel) {
    return ConversationList(
      viewModel.userConversations,
      viewModel.currentUserId,
      (index) => _navigateToChatView(viewModel.userConversations[index]),
    );
  }

  void _navigateToChatView(Conversation conversation) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder:
            (context) => ChangeNotifierProvider(
              // IMPORTANT: Pass the conversation to the ViewModel's constructor
              create: (_) => ChatViewModel(conversation),
              // The child is our new ChatPage
              child: const ChatPage(),
            ),
      ),
    );
  }
}
