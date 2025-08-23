import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/contact/data/model/contact_create_model.dart';
import 'package:pulse_chat/features/contact/data/model/contact_update_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../model/contact_model.dart';

part 'contact_service.g.dart';

//dart pub run build_runner build

@RestApi()
abstract class ContactService {
  factory ContactService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _ContactService;

  @GET("/contacts")
  Future<ListResponse<ContactModel>> fetchContacts(@Query("type") String type);

  @POST("/contacts/")
  Future<ObjectResponse<ContactModel>> createCotact(
    @Body() ContactCreateModel contactCreate,
  );

  @PUT("/contacts/{id}")
  Future<ObjectResponse<ContactModel>> updateContact(
    @Path("id") int id,
    @Body() ContactUpdateModel contactUpdate,
  );

  @DELETE("/contacts/{id}")
  Future<MessageResponse> deleteContact(@Path("id") int id);
}
