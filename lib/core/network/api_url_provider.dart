import 'package:flutter_dotenv/flutter_dotenv.dart';

/// This class was created for providing api endpoints
/// Used in api client requests
class ApiUrlProvider {
  late final String _apiUrl;
  late final String _host;
  late final String _port;
  late final String _apiVersion;
  late final String _secure;

  ApiUrlProvider._internal() {
    _apiVersion = dotenv.env['API_VERSION'] ?? '1';
    _host = dotenv.env['HOST'] ?? '192.168.1.1';
    _port = dotenv.env['PORT'] ?? '8000';
    _secure = dotenv.env['SECURE'] ?? 'http';
    _apiUrl = "$_secure://$_host:$_port";
  }

  static final ApiUrlProvider _instance = ApiUrlProvider._internal();

  factory ApiUrlProvider() => _instance;

  String get baseUrl => "$_apiUrl/api/v$_apiVersion";

  String get baseWebsocket => "ws://$_host:$_port/ws";
}
