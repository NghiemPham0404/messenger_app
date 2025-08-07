import 'package:pulse_chat/features/conversation/domain/repositories/socket_repo.dart';

class ConnectToSocket {
  final SocketRepository _socketRepo;

  ConnectToSocket({required SocketRepository socketRepo})
    : _socketRepo = socketRepo;

  void call() {
    _socketRepo.connectToSoket();
  }
}
