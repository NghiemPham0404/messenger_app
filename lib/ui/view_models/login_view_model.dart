import 'dart:async';

import 'package:chatting_app/data/models/account.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/response/auth_response.dart';

class LoginViewModel{

  final AuthRepo _authRepo = AuthRepo();

  LoginViewModel.internal();

  static final LoginViewModel _instance = LoginViewModel.internal();

  factory LoginViewModel() => _instance;
 
  void login(String email, String password){
    _authRepo.login(email, password);
  }

  Stream<AuthResponse> getAuthReponse() => _authRepo.getAuthReponse();

  void requestCurrentUser(){
    _authRepo.requestGetCurrentUser();
  }

  Stream<UserOut> getCurrentUser() =>_authRepo.getCurrentUser();

}