import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';

abstract class ContactRepository {
  Future<ListResponse<Contact>> fetchContacts(String type);

  Future<ObjectResponse<Contact>> createContact({
    required int contactUserId,
    required int status,
  });

  Future<ObjectResponse<Contact>> updateContact({
    required int id,
    required String action,
  });

  Future<MessageResponse> deleteContact({required int id});
}
