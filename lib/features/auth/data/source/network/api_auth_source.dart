import 'package:pulse_chat/core/network/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../models/auth_response_model.dart';
import '../../models/user_model.dart';
import '../../models/login_google_model.dart';
import '../../models/login_model.dart';
import '../../models/refresh_token_model.dart';
import '../../models/signup_model.dart';

part 'api_auth_source.g.dart';

@RestApi()
abstract class ApiAuthSource {
  factory ApiAuthSource(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger errorLogger,
  }) = _ApiAuthSource;

  @POST("/auth/token")
  Future<AuthResponseModel> login(@Body() LoginModel body);

  @GET("/info")
  Future<ObjectResponse<UserModel>> getCurrentUser(
    @Header("Authorization") String token,
  );

  @POST("/auth/sign-up")
  Future<ObjectResponse<UserModel>> signUp(@Body() SignUpModel signUpBody);

  @POST("/auth/google")
  Future<AuthResponseModel> loginByGoogle(@Body() GoogleLoginModel body);

  @POST("/auth/refresh")
  Future<AuthResponseModel> refreshToken(@Body() RefreshTokenModel body);
}
