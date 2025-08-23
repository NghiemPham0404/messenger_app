import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:flutter/cupertino.dart';

import '../../../auth/domain/entities/user.dart';

class SettingNotifier extends ChangeNotifier {
  late final LocalAuthSource _localAuthSource;

  SettingNotifier({required LocalAuthSource localAuthSource})
    : _localAuthSource = localAuthSource;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  User? get currentUser => _localAuthSource.getCachedUser();
}
