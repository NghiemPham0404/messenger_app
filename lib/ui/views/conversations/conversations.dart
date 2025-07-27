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
                body:
                    viewModel.userConversations.isEmpty && !viewModel.isLoading
                        ? _emptyConversationsPage()
                        : _getConversationList(viewModel),
              ),
            ),
          ),
    );
  }

  Widget _getHeader() {
    return SearchAppBar();
  }

  Widget _emptyConversationsPage() {
    return Center(child: Text("please start a new conversation"));
  }

  Widget _getConversationList(ConversationsViewModel viewModel) {
    List<Conversation> conversations = viewModel.userConversations;

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.requestUserConversation();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(), // Important!
        itemCount: conversations.length + (viewModel.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (viewModel.isLoading && index == conversations.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return ConversationListTile(
            conversations[index],
            () => _navigateToChatView(conversations[index]),
            viewModel.currentUserId,
          );
        },
      ),
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
