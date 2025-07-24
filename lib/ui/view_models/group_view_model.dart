import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/models/group_member.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/contact_repo.dart';
import 'package:chatting_app/data/repositories/group_member_repo.dart';
import 'package:chatting_app/data/repositories/group_repo.dart';
import 'package:chatting_app/data/repositories/media_file_repo.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'group_view_model.create.dart';

class GroupViewModel extends ChangeNotifier {
  final ContactRepo _contactRepo = ContactRepo();
  final AuthRepo _authRepo = AuthRepo();

  final _groupRepo = GroupRepo();
  final _groupMemberRepo = GroupMemberRepo();
  final _fileRepo = MediaFileRepo();

  XFile? _choosenAvatar;
  XFile? get choosenAvatar => _choosenAvatar;

  ListResponse<Group>? _groupList;
  ListResponse<Group>? get groupList => _groupList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<GroupMemberSelection>? _groupInitialUsers;
  List<GroupMemberSelection>? get groupInitialUser => _groupInitialUsers;

  GroupViewModel() {
    getUserGroups(1);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void getUserGroups(int page) async {
    _setLoading(true);
    try {
      final response = await _contactRepo.fetchGroupRequests(
        _authRepo.currentUser!.id,
      );
      if (page == 1) {
        _groupList = response;
      } else {
        _groupList?.page = response.page;
        _groupList?.results = response.results;
      }
    } on DioException catch (e) {
      _setError("[Group List]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  void getNextPage() {
    getUserGroups((_groupList?.page ?? 0) + 1);
  }
}
