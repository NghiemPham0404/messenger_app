import 'dart:async';

import 'package:chatting_app/ui/view_models/chat_view_model.dart';
import 'package:chatting_app/ui/widgets/chat/chat_header.dart';
import 'package:chatting_app/ui/widgets/chat/chat_bubble.dart';
import 'package:chatting_app/ui/widgets/chat/chat_input_area.dart';
import 'package:chatting_app/ui/widgets/chat/message_actions.dart';
import 'package:chatting_app/util/web_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import your models and ViewModel

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  final _webSocketService = WebSocketService();
  StreamSubscription? _webSocketSubscription;

  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to ensure the ViewModel is available before we use it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the ViewModel and call its initialize method.
      // This is the correct way to start data loading.
      final viewModel = Provider.of<ChatViewModel>(context, listen: false);
      viewModel.initialize();
      observeChange(viewModel);
    });

    // Add a listener to the scroll controller to detect when the user
    // has scrolled to the top of the list.
    _scrollController.addListener(_onScroll);
  }

  void observeChange(ChatViewModel chatViewModel) {
    _webSocketSubscription?.cancel();
    _webSocketSubscription = _webSocketService.getMessageStream().listen((
      data,
    ) {
      debugPrint('[WS] Received: $data');
      chatViewModel.updateNewMessage(data);
    }, onError: (error) => debugPrint('[WS] Error: $error'));

    if (chatViewModel.groupId != null) {
      _webSocketService.joinGroup(chatViewModel.groupId!);
    }
  }

  @override
  void dispose() {
    // Always dispose of controllers to prevent memory leaks.
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _webSocketService.leaveGroup();
    super.dispose();
  }

  void _onScroll() {
    // Check if we are at the top of the list
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      final viewModel = Provider.of<ChatViewModel>(context, listen: false);
      // Prevent multiple requests while one is already in progress
      if (!viewModel.isLoading) {
        viewModel.requestOlderMessages();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to get access to the ViewModel and automatically rebuild
    // the UI when notifyListeners() is called.
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                _buildChatHeader(viewModel),
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

  Widget _buildMessagesList(ChatViewModel viewModel) {
    // loading screen
    if (viewModel.isLoading && viewModel.messages.isEmpty) {
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
      itemCount: viewModel.messages.length + (viewModel.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the very top (which is the end of the reversed list)
        if (viewModel.isLoading && index == viewModel.messages.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final message = viewModel.messages[index];
        final isMe = message.userId == viewModel.userId;
        return MessageBubble(
          key: Key(message.id),
          message: message,
          isMe: isMe,
          onTap: () => _downloadFile(index, viewModel),
          onLongPress:
              () => showMessageOptions(
                context,
                message,
                (messageId) => _deleteMessage(messageId, viewModel),
                (messageId, newTextContent) =>
                    _editMessage(messageId, newTextContent, viewModel),
              ),
        );
      },
    );
  }

  Widget _buildMessageInputBar() {
    return ChatInputArea();
  }

  Widget _buildChatHeader(ChatViewModel viewModel) {
    return ChatHeader(conversation: viewModel.conversation!);
  }

  void _downloadFile(int index, ChatViewModel viewModel) {
    viewModel.downloadFile(index);
  }

  void _editMessage(
    String messageId,
    String newTextContent,
    ChatViewModel viewModel,
  ) {
    viewModel.editSentMessage(
      messageId: messageId,
      updateTextContent: newTextContent,
    );
  }

  void _deleteMessage(String messageId, ChatViewModel viewModel) {
    viewModel.deleteMessage(messageId);
  }
}
