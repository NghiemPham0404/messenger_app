import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/repositories/contact_repository.dart';

class BlockUser {
  final ContactRepository _contactRepo;

  BlockUser(ContactRepository contactRepo) : _contactRepo = contactRepo;

  Future<ObjectResponse<Contact>> call(int contactUserId) {
    return _contactRepo.createContact(contactUserId: contactUserId, status: 2);
  }
}
