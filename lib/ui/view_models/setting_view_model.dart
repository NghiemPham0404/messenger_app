import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:flutter/cupertino.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  User? get currentUser => _authRepo.currentUser;

  void logOut() {
    _authRepo.logOut();
    _authRepo.signOutGoogle();
  }
}
