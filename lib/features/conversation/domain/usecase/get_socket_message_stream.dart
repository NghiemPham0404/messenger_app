import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/socket_repo.dart';

class GetSocketMessageStream {
  final SocketRepository _socketRepo;

  GetSocketMessageStream({required SocketRepository socketRepo})
    : _socketRepo = socketRepo;

  Stream<Message> call() {
    return _socketRepo.getMessageStream();
  }
}
