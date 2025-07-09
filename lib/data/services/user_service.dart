import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_service.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl, ParseErrorLogger errorLogger}) =
      _UserService;

  @GET("/users/")
  Future<ListResponse<UserExtended>> getUsers(
    @Query("keyword") String keyword,
    @Query("page") int page,
  );

  @GET("/users/{id}")
  Future<ObjectResponse<UserExtended>> getUser(@Path("id") int id);
}
