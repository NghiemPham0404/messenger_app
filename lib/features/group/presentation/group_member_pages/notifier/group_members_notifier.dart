import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_update.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/delete_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/get_group_members.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/update_member.dart';

class GroupMembersNotifier extends ChangeNotifier {
  GroupMembersNotifier({
    required GetGroupMembers getGroupMembers,
    required UpdateMember updateMember,
    required DeleteMember deleteMember,
  }) : _getGroupMembers = getGroupMembers,
       _updateMember = updateMember,
       _deleteMember = deleteMember;

  // DEPENDENCIES -------------------------------------------------------------------------------
  final GetGroupMembers _getGroupMembers;

  final UpdateMember _updateMember;

  final DeleteMember _deleteMember;

  // PROPERTIES-----------------------------------------------------------------------------------
  bool _loadingMembers = false;
  bool get loadingMembers => _loadingMembers;

  String? _errorMembers;
  String? get errorMembers => _errorMembers;

  int _membersPage = 0;
  int get membersPage => _membersPage;

  bool _membersHasNext = false;
  bool get memberHasNext => _membersHasNext;

  List<GroupMember> _groupMembers = [];
  List<GroupMember> get groupMembers => _groupMembers;

  // METHODS -------------------------------------------------------------------------------------

  void getGroupMembers(int groupId, int page) async {
    _loadingMembers = true;
    _errorMembers = null;
    try {
      final response = await _getGroupMembers(groupId, page: page);
      final members = response.results;
      _groupMembers = members;
      _membersPage = response.page;
      _membersHasNext = response.page < response.totalPages;
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group - members] $detail");
    } catch (e) {
      debugPrint("[Group - members] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }

  void getGroupMembersNext(int groupId) async {
    getGroupMembers(groupId, _membersPage + 1);
  }

  void grantSubHost(int groupId, int groupMemberId) async {
    try {
      final groupMemberUpdate = GroupMemberUpdate(
        isHost: false,
        isSubHost: true,
        status: 1,
      );
      final response = await _updateMember(
        groupId: groupId,
        groupMemberId: groupMemberId,
        groupMemberUpdate: groupMemberUpdate,
      );
      if (response.success) {
        int index = _groupMembers.indexWhere(
          (item) => item.id == groupMemberId,
        );
        _groupMembers[index] = response.result;
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group member - grant subhost] $detail");
    } catch (e) {
      debugPrint("[Group member - grant subhost] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }

  void deleteGroupMember(int groupId, int groupMemberId) async {
    try {
      final response = await _deleteMember(groupId, groupMemberId);
      if (response.success) {
        _groupMembers.removeWhere((item) => item.id == groupMemberId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group - delete member] $detail");
    } catch (e) {
      debugPrint("[Group - delete member] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }
}
