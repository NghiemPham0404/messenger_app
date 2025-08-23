import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_user_conversation.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/mark_conversation_check.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/refresh_user_conversation.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/update_conversation.dart';

class ConversationNotifier extends ChangeNotifier {
  final GetUserConversations _getUserConversations;
  final RefreshUserConversations _refreshUserConversations;
  final UpdateConversation _updateConversation;
  final MarkConversationChecked _markConversationChecked;
  final LocalAuthSource _localAuthSource;
  get localAuthSource => _localAuthSource;

  ConversationNotifier({
    required GetUserConversations getUserConversations,
    required RefreshUserConversations refreshUserConversations,
    required UpdateConversation updateConversation,
    required MarkConversationChecked markConversationChecked,
    required LocalAuthSource localAuthSource,
  }) : _getUserConversations = getUserConversations,
       _refreshUserConversations = refreshUserConversations,
       _updateConversation = updateConversation,
       _markConversationChecked = markConversationChecked,
       _localAuthSource = localAuthSource {
    requestUserConversations();
  }

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void requestUserConversations() async {
    _conversations = [];
    _setLoading(true);
    try {
      debugPrint(
        "current user : ${_localAuthSource.getCachedUser().toString()}}",
      );
      if (_localAuthSource.getCachedUser() != null) {
        _conversations = await _getUserConversations(
          _localAuthSource.getCachedUser()?.id ?? 0,
        );
      }
    } on DioException catch (e) {
      debugPrint("[User conversations] detail : ${e.response!.data["detail"]}");
      _setError(e.response!.data["detail"]);
    } catch (e) {
      debugPrint("[User conversations] detail : $e");
      _setError(e.toString());
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void refreshUserConversations() async {
    _conversations = [];
    _setLoading(true);
    try {
      if (_localAuthSource.getCachedUser() != null) {
        _conversations = await _refreshUserConversations(
          _localAuthSource.getCachedUser()?.id ?? 0,
        );
      }
    } on DioException catch (e) {
      debugPrint(
        "[User conversations -- refresh] detail : ${e.response!.data["detail"]}",
      );
      _setError(e.response!.data["detail"]);
    } catch (e) {
      debugPrint("[User conversations -- refresh] detail : $e");
      _setError(e.toString());
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void addNewConversation(Conversation conversation) {
    _conversations.add(conversation);
    notifyListeners();
  }

  void markConversationChecked(String conversationId) async {
    int index = _conversations.indexWhere(
      (element) => element.id == conversationId,
    );
    if (index != -1) {
      _conversations[index].uncheckedCount = 0;
    }
    await _markConversationChecked(conversationId);
    notifyListeners();
  }

  void updateNewcomingConversation(Conversation newConversation) {
    _updateConversation(newConversation);
    int index = _conversations.indexWhere(
      (element) => element.id == newConversation.id,
    );
    if (index != -1) {
      _conversations[index].content = newConversation.content;
      _conversations[index].timestamp = newConversation.timestamp;
      _conversations[index].uncheckedCount =
          (_conversations[index].uncheckedCount ?? 0) + 1;
      _conversations[index].sender.id = newConversation.sender.id;
      _conversations[index].sender.name = newConversation.sender.name;
      _conversations[index].sender.avatar = newConversation.sender.avatar;
    } else {
      addNewConversation(newConversation);
    }
    notifyListeners();
  }

  List<Conversation> get userConversations => _conversations;
}
