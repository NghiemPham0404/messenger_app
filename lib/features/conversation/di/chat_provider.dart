import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/delete_message.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_socket_message_stream.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/update_message.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_option_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_socket_notifier.dart';
import 'package:pulse_chat/features/media/domain/usecase/check_existence_file.dart';
import 'package:pulse_chat/features/media/domain/usecase/download_media_file.dart';
import 'package:pulse_chat/features/conversation/data/repositories/direct_chat_repo_impl.dart';
import 'package:pulse_chat/features/conversation/data/repositories/group_chat_repo_impl.dart';
import 'package:pulse_chat/features/conversation/data/source/network/chat_service.dart';
import 'package:pulse_chat/features/conversation/data/source/network/conversation_service.dart';
import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/chat_repo.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_chat_history.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/send_message.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_download.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_header_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_history_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_input_notifier.dart';

import '../../media/domain/usecase/upload_image_file.dart';
import '../../media/domain/usecase/upload_media_file.dart';

// Service------------------------------------------------------------------
List<SingleChildWidget> chatServiceProviders = [
  Provider<ConversationService>(
    create: (context) => context.read<ApiClient>().conversationApi,
  ),
  Provider<ChatService>(create: (context) => context.read<ApiClient>().chatApi),
];
// UseCase-------------------------------------------------------------------
List<SingleChildWidget> chatUsecaseProviders = [
  Provider<GetChatHistory>(
    create:
        (context) =>
            GetChatHistory(chatRepository: context.read<ChatRepository>()),
  ),
  Provider<SendMessage>(
    create:
        (context) =>
            SendMessage(chatRepository: context.read<ChatRepository>()),
  ),
  Provider<UpdateMessage>(
    create:
        (context) =>
            UpdateMessage(chatRepository: context.read<ChatRepository>()),
  ),
  Provider<DeleteMessage>(
    create:
        (context) =>
            DeleteMessage(chatRepository: context.read<ChatRepository>()),
  ),
];

List<SingleChildWidget> directChatProviders = [
  // Service------------------------------------------------------------------
  ...chatServiceProviders,
  // Repository----------------------------------------------------------------
  Provider<ChatRepository>(
    create:
        (context) => DirectChatRepoImpl(
          conversationService: context.read<ConversationService>(),
          chatService: context.read<ChatService>(),
          localAuthSource: context.read<LocalAuthSource>(),
        ),
  ),
  // Usecase ------------------------------------------------------------------
  ...chatUsecaseProviders,
];

List<SingleChildWidget> groupChatProviders = [
  // Service------------------------------------------------------------------
  ...chatServiceProviders,
  // Repository----------------------------------------------------------------
  Provider<ChatRepository>(
    create:
        (context) => GroupChatRepoImpl(
          conversationService: context.read<ConversationService>(),
          chatService: context.read<ChatService>(),
          localAuthSource: context.read<LocalAuthSource>(),
        ),
  ),
  // UseCase-------------------------------------------------------------------
  ...chatUsecaseProviders,
];

List<SingleChildWidget> getChatProviders(
  int currentUserId,
  Conversation conversation,
) {
  debugPrint("current user id : $currentUserId");
  final groupId = conversation.groupId;
  final otherUserId =
      conversation.userId == currentUserId
          ? conversation.receiverId
          : conversation.userId;
  debugPrint("other id : ${otherUserId ?? groupId ?? 0}");

  return [
    if (groupId != null) ...groupChatProviders,
    if (conversation.receiverId != null) ...directChatProviders,
    ChangeNotifierProvider(
      create: (context) => ChatHeaderNotifier(conversation: conversation),
    ),
    ChangeNotifierProvider(
      create:
          (context) => ChatHistoryNotifier(
            getChatHistory: context.read<GetChatHistory>(),
            checkExistenceFile: context.read<CheckExistenceFile>(),
            otherId: groupId ?? otherUserId ?? 0,
            localAuthSource: context.read<LocalAuthSource>(),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (context) => ChatInputNotifier(
            chatNotifier: context.read<ChatHistoryNotifier>(),
            localAuthSource: context.read<LocalAuthSource>(),
            sendMessage: context.read<SendMessage>(),
            uploadImageFile: context.read<UploadImageFile>(),
            uploadMediaFile: context.read<UploadMediaFile>(),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (context) => ChatDownloadNotifier(
            chatHistoryNotifier: context.read<ChatHistoryNotifier>(),
            downloadMediaFile: context.read<DownloadMediaFile>(),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (context) => ChatOptionNotifier(
            chatHistoryNotifier: context.read<ChatHistoryNotifier>(),
            updateMessage: context.read<UpdateMessage>(),
            deleteMessage: context.read<DeleteMessage>(),
          ),
    ),
    ChangeNotifierProvider<ChatSocketNotifier>(
      create:
          (context) => ChatSocketNotifier(
            chatHistoryNotifier: context.read<ChatHistoryNotifier>(),
            getSocketMessageStream: context.read<GetSocketMessageStream>(),
          ),
    ),
  ];
}
