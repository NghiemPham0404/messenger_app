import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/features/contact/domain/repositories/contact_repository.dart';

class DeleteContact {
  final ContactRepository _contactRepo;

  DeleteContact(ContactRepository contactRepo) : _contactRepo = contactRepo;

  Future<MessageResponse> call(int contactId) {
    return _contactRepo.deleteContact(id: contactId);
  }
}
