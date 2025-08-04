import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/conversation_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ConversationsViewModel extends ChangeNotifier {
  final _conversationRepo = ConversationRepo();

  final _authRepo = AuthRepo();

  int get currentUserId => _authRepo.currentUser!.id;

  ConversationsViewModel() {
    requestUserConversation();
  }

  List<Conversation> _conversations = [];

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

  void requestUserConversation() async {
    _conversations = [];
    _setLoading(true);
    try {
      if (_authRepo.currentUser != null) {
        _conversations = await _conversationRepo.requestUserConversations(
          _authRepo.currentUser!.id,
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
      if (_authRepo.currentUser != null) {
        _conversations = await _conversationRepo.refreshUserConversations(
          _authRepo.currentUser!.id,
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

  List<Conversation> get userConversations => _conversations;
}
