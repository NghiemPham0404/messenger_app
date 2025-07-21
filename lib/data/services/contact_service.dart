import 'package:chatting_app/data/models/contact.dart';
import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:chatting_app/data/responses/message_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

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
  Future<ListResponse<Contact>> fetchContacts(@Query("type") String type);

  @POST("/contacts/")
  Future<ObjectResponse<Contact>> createCotacts(
    @Body() ContactCreate contactCreate,
  );

  @PUT("/contacts/{id}")
  Future<ObjectResponse<Contact>> updateContacts(
    @Path("id") int id,
    @Body() Map<String, dynamic> contactUpdate,
  );

  @DELETE("/contacts/{id}")
  Future<MessageResponse> delete(@Path("id") int id);

  @GET("/users/{id}/groups")
  Future<ListResponse<Group>> fetchUserGroup(
    @Path("id") int id,
    @Query("page") int page,
  );
}
