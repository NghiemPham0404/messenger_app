import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/conversation/data/repositories/websocket_repo_impl.dart';
import 'package:pulse_chat/features/conversation/data/source/websocket/web_socket_service.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/socket_repo.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/conect_to_socket.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/disconect_from_socket.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_socket_message_stream.dart';

final List<SingleChildWidget> socketProviders = [
  // SERVICE
  Provider<WebSocketService>(
    create:
        (context) =>
            WebSocketService(localAuthSource: context.read<LocalAuthSource>()),
  ),
  // REPOSITORY
  Provider<SocketRepository>(
    create:
        (context) => WebsocketRepoImpl(
          webSocketService: context.read<WebSocketService>(),
        ),
  ),

  // USECASE
  Provider<ConnectToSocket>(
    create:
        (context) =>
            ConnectToSocket(socketRepo: context.read<SocketRepository>()),
  ),
  Provider<DisconectFromSocket>(
    create:
        (context) =>
            DisconectFromSocket(socketRepo: context.read<SocketRepository>()),
  ),
  Provider<GetSocketMessageStream>(
    create:
        (context) => GetSocketMessageStream(
          socketRepo: context.read<SocketRepository>(),
        ),
  ),

  // NOTIFIER
];
