import 'package:chatting_app/data/models/account.dart';
import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:chatting_app/data/responses/auth_response.dart';

part 'auth_api.g.dart';

//  dart run build_runner build --delete-conflicting-outputs

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthApi;

  @POST("/auth/token")
  Future<AuthResponse> login(@Body() LoginModel body);

  @GET("/info")
  Future<ObjectResponse<User>> getCurrentUser(
    @Header("Authorization") String token,
  );

  @POST("/auth/sign-up")
  Future<ObjectResponse<User>> signUp(@Body() SignUpModel signUpBody);

  @POST("/auth/google")
  Future<AuthResponse> loginByGoogle(@Body() GoogleLoginModel body);
}
