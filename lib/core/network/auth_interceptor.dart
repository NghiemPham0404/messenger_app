import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final LocalAuthSource tokenStorage;

  AuthInterceptor(this.tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
