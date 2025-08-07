import 'package:pulse_chat/features/conversation/di/chat_provider.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/conversation_page/change_notifier/conversation_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/view/chat_page.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/conversation_page/change_notifier/conversation_socket_notifier.dart';
import 'package:pulse_chat/ui/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/conversation.dart';
import '../../../components/conversation_item.dart';

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ConversationSocketNotifier>(
        context,
        listen: false,
      );
      viewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationNotifier>(
      builder:
          (context, notifier, child) => CupertinoPageScaffold(
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(title: _getHeader()),
                body:
                    notifier.userConversations.isEmpty && !notifier.isLoading
                        ? _emptyConversationsPage()
                        : _getConversationList(notifier),
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

  Widget _getConversationList(ConversationNotifier viewModel) {
    List<Conversation> conversations = viewModel.userConversations;

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.refreshUserConversations();
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

          return ConversationItem(
            conversations[index],
            () => _navigateToChatView(
              viewModel.localAuthSource.getCachedUser()?.id ?? 0,
              conversations[index],
            ),
            viewModel.localAuthSource.getCachedUser()?.id ?? 0,
          );
        },
      ),
    );
  }

  void _navigateToChatView(int currentUserId, Conversation conversation) {
    context.read<ConversationNotifier>().markConversationChecked(
      conversation.id,
    );
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder:
            (context) => MultiProvider(
              providers: getChatProviders(currentUserId, conversation),
              child: const ChatPage(),
            ),
      ),
    );
  }
}
