import 'package:pulse_chat/core/util/page_state.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_header_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_history_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/components/chat_header.dart';
import 'package:pulse_chat/features/conversation/presentation/components/chat_bubble.dart';
import 'package:pulse_chat/features/conversation/presentation/components/chat_input_area.dart';
import 'package:pulse_chat/features/conversation/presentation/components/message_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_option_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_socket_notifier.dart';

// Import your models and ViewModel

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  late final Function() _scrollListener;

  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the ViewModel is available before we use it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ChatHistoryNotifier>(
        context,
        listen: false,
      );
      viewModel.initialize();

      final chatSocketNotifier = Provider.of<ChatSocketNotifier>(
        context,
        listen: false,
      );
      chatSocketNotifier.initialize();

      // Add a listener to the scroll controller to detect when the user
      // has scrolled to the top of the list.
      _scrollListener = () => _onScroll(viewModel);
      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    // Always dispose of controllers to prevent memory leaks.
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll(ChatHistoryNotifier viewModel) {
    // Check if we are at the top of the list
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      if (viewModel.pageState != PageState.loading) {
        viewModel.requestOlderMessages();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to get access to the ViewModel and automatically rebuild
    // the UI when notifyListeners() is called.
    return Consumer<ChatHistoryNotifier>(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                _buildChatHeader(),
                if (viewModel.errorMessage != null)
                  Container(
                    width: double.infinity,
                    color: Colors.redAccent,
                    child: Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                // --- Message List Area ---
                Expanded(child: _buildMessagesList(viewModel)),
                // --- Message Input Area ---
                _buildMessageInputBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesList(ChatHistoryNotifier viewModel) {
    // loading screen
    if (viewModel.pageState == PageState.loading &&
        viewModel.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // error page
    if (viewModel.errorMessage != null && viewModel.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: ${viewModel.errorMessage}'),
        ),
      );
    }

    // no message
    if (viewModel.messages.isEmpty) {
      return const Center(child: Text("No messages yet. Say hello!"));
    }

    return ListView.builder(
      controller: _scrollController,
      // reverse: true makes the list start from the bottom, which is standard for chat apps.
      reverse: true,
      padding: const EdgeInsets.all(8.0),
      itemCount:
          viewModel.messages.length +
          (viewModel.pageState == PageState.loading ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the very top (which is the end of the reversed list)
        if (viewModel.pageState == PageState.loading &&
            index == viewModel.messages.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final message = viewModel.messages[index];
        final isMe = message.userId == viewModel.userId;
        return MessageBubble(
          key: Key(message.id),
          index: index,
          message: message,
          isMe: isMe,
          onLongPress:
              () => showMessageOptions(
                context,
                message,
                (messageId) => _deleteMessage(
                  messageId,
                  context.read<ChatOptionNotifier>(),
                ),
                (messageId, newTextContent) => _editMessage(
                  messageId,
                  newTextContent,
                  context.read<ChatOptionNotifier>(),
                ),
              ),
        );
      },
    );
  }

  Widget _buildMessageInputBar() {
    return ChatInputArea();
  }

  Widget _buildChatHeader() {
    return Consumer<ChatHeaderNotifier>(
      builder:
          (context, chatHeaderNotifier, child) =>
              ChatHeader(conversation: chatHeaderNotifier.conversation),
    );
  }

  void _editMessage(
    String messageId,
    String newTextContent,
    ChatOptionNotifier chatOptionNotifier,
  ) {
    chatOptionNotifier.editSentMessage(
      messageId: messageId,
      updateTextContent: newTextContent,
    );
  }

  void _deleteMessage(String messageId, ChatOptionNotifier chatOptionNotifier) {
    chatOptionNotifier.deleteMessage(messageId);
  }
}
