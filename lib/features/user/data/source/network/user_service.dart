import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/user/data/model/user_extended_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_service.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl, ParseErrorLogger errorLogger}) =
      _UserService;

  @GET("/users/")
  Future<ListResponse<UserExtendedModel>> getUsers(
    @Query("keyword") String keyword,
    @Query("page") int page,
  );

  @GET("/users/{id}")
  Future<ObjectResponse<UserExtendedModel>> getUser(@Path("id") int id);
}
