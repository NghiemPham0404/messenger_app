import 'package:pulse_chat/features/conversation/domain/repositories/socket_repo.dart';

class DisconectFromSocket {
  final SocketRepository _socketRepo;

  DisconectFromSocket({required SocketRepository socketRepo})
    : _socketRepo = socketRepo;

  void call() {
    _socketRepo.disconnectFromSoket();
  }
}
