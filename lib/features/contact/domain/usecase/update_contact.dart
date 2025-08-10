import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/repositories/contact_repository.dart';

enum UpdateAction { accept, block }

class AcceptFriendRequest {
  final ContactRepository _contactRepo;

  AcceptFriendRequest(ContactRepository contactRepo)
    : _contactRepo = contactRepo;

  Future<ObjectResponse<Contact>> call(int contactId) {
    return _contactRepo.updateContact(
      id: contactId,
      action: UpdateAction.accept.name,
    );
  }
}

class BlockContact {
  final ContactRepository _contactRepo;

  BlockContact(ContactRepository contactRepo) : _contactRepo = contactRepo;

  Future<ObjectResponse<Contact>> call(int contactId) {
    return _contactRepo.updateContact(
      id: contactId,
      action: UpdateAction.block.name,
    );
  }
}
