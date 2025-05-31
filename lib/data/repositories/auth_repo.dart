import 'dart:async';

import 'package:chatting_app/data/datasource/auth_source.dart';
import 'package:chatting_app/data/models/account.dart';
import 'package:chatting_app/data/response/auth_response.dart';

class AuthRepo {
  final AuthSource _authSource = AuthSource();
  final StreamController<UserOut> _userOutStream = StreamController.broadcast();
  final StreamController<AuthResponse> _authResponse = StreamController.broadcast();

  Future<void> login(String email, String password) async{
    if(!_authResponse.isClosed){
        await _authSource.login(email, password).then((data){
        if(data!=null) _authResponse.add(data);
      });
    }
  }

  Future<void> requestGetCurrentUser() async{
    if(!_userOutStream.isClosed){
      await _authSource.getCurrentUser().then((data){
        if (data != null) _userOutStream.add(data);
      });
    }
  }

  Stream<AuthResponse> getAuthReponse(){
    return _authResponse.stream;
  }

  Stream<UserOut> getCurrentUser(){
    return _userOutStream.stream;
  }
}