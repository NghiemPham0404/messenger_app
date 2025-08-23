import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/conversation/data/repositories/conversation_repo_impl.dart';
import 'package:pulse_chat/features/conversation/data/source/local/local_conversation_source.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/conversation_repo.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/conect_to_socket.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/disconect_from_socket.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_socket_message_stream.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_user_conversation.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/mark_conversation_check.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/refresh_user_conversation.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/update_conversation.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/conversation_page/change_notifier/conversation_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/conversation_page/change_notifier/conversation_socket_notifier.dart';

import '../data/source/network/conversation_service.dart';

List<SingleChildWidget> conversationsProviders = [
  // Service & Source
  Provider<LocalConversationSource>(
    create: (context) => LocalConversationSource(),
  ),

  Provider<ConversationService>(
    create: (context) => context.read<ApiClient>().conversationApi,
  ),
  // Repo
  Provider<ConversationRepository>(
    create:
        (context) => ConversationRepoImp(
          localConversationSource: context.read<LocalConversationSource>(),
          conversationService: context.read<ConversationService>(),
        ),
  ),
  // UseCases
  Provider<GetUserConversations>(
    create:
        (context) => GetUserConversations(
          conversationRepo: context.read<ConversationRepository>(),
        ),
  ),

  Provider<RefreshUserConversations>(
    create:
        (context) => RefreshUserConversations(
          conversationRepo: context.read<ConversationRepository>(),
        ),
  ),
  Provider<MarkConversationChecked>(
    create:
        (context) =>
            MarkConversationChecked(context.read<ConversationRepository>()),
  ),
  Provider<UpdateConversation>(
    create:
        (context) => UpdateConversation(context.read<ConversationRepository>()),
  ),
  // Notifier
  ChangeNotifierProvider<ConversationNotifier>(
    create:
        (context) => ConversationNotifier(
          localAuthSource: context.read<LocalAuthSource>(),
          getUserConversations: context.read<GetUserConversations>(),
          refreshUserConversations: context.read<RefreshUserConversations>(),
          markConversationChecked: context.read<MarkConversationChecked>(),
          updateConversation: context.read<UpdateConversation>(),
        ),
  ),
  ChangeNotifierProvider<ConversationSocketNotifier>(
    create:
        (context) => ConversationSocketNotifier(
          conversationNotifier: context.read<ConversationNotifier>(),
          getSocketConversationStream: context.read<GetSocketMessageStream>(),
          conectToSocket: context.read<ConnectToSocket>(),
          disconectFromSocket: context.read<DisconectFromSocket>(),
        ),
  ),
];
