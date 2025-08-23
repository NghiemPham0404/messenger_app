import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/repositories/contact_repository.dart';

enum ContactType { accept, pending, request, block }

class GetUserContacts {
  final ContactRepository _contactRepo;

  GetUserContacts(ContactRepository contactRepo) : _contactRepo = contactRepo;

  Future<ListResponse<Contact>> call() {
    return _contactRepo.fetchContacts(ContactType.accept.name);
  }
}

class GetUserPendingRequests {
  final ContactRepository _contactRepo;

  GetUserPendingRequests(ContactRepository contactRepo)
    : _contactRepo = contactRepo;

  Future<ListResponse<Contact>> call() {
    return _contactRepo.fetchContacts(ContactType.pending.name);
  }
}

class GetUserSentRequests {
  final ContactRepository _contactRepo;

  GetUserSentRequests(ContactRepository contactRepo)
    : _contactRepo = contactRepo;

  Future<ListResponse<Contact>> call() {
    return _contactRepo.fetchContacts(ContactType.request.name);
  }
}
