class AuthResponse{
  String accessToken;
  String refreshToken;
  String bearerType;

  AuthResponse(
    {
      required this.accessToken,
      required this.bearerType,
      required this.refreshToken
    }
  );

  factory AuthResponse.fromJson(Map<String, dynamic> map){
    return AuthResponse(
      accessToken: map['access_token'],
      refreshToken: map['refresh_token'],
      bearerType: map['token_type'],
    );
  }
}