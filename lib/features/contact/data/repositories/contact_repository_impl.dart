import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/contact/data/model/contact_create_model.dart';
import 'package:pulse_chat/features/contact/data/model/contact_update_model.dart';
import 'package:pulse_chat/features/contact/data/source/network/contact_service.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl extends ContactRepository {
  final LocalAuthSource _localAuthSource;

  final ContactService _contactService;

  ContactRepositoryImpl({
    required LocalAuthSource localAuthSource,
    required ContactService contactService,
  }) : _contactService = contactService,
       _localAuthSource = localAuthSource;

  @override
  Future<ListResponse<Contact>> fetchContacts(String type) async {
    return _contactService.fetchContacts(type);
  }

  @override
  Future<ObjectResponse<Contact>> createContact({
    required int contactUserId,
    required int status,
  }) {
    final currentUser = _localAuthSource.getCachedUser();
    if (currentUser != null) {
      return _contactService.createCotact(
        ContactCreateModel(
          userId: currentUser.id,
          contactUserId: contactUserId,
          status: status,
        ),
      );
    } else {
      throw {"detail": "Unauthorized"};
    }
  }

  @override
  Future<ObjectResponse<Contact>> updateContact({
    required int id,
    required String action,
  }) {
    final contactUpdateModel = ContactUpdateModel(action: action);
    return _contactService.updateContact(id, contactUpdateModel);
  }

  @override
  Future<MessageResponse> deleteContact({required int id}) {
    return _contactService.deleteContact(id);
  }
}
