import 'dart:async';

import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/conversation_repo.dart';
import 'package:flutter/cupertino.dart';

class ConversationsViewModel extends ChangeNotifier {
  final _conversationRepo = ConversationRepo();

  final _authRepo = AuthRepo();

  int get currentUserId => _authRepo.currentUser!.id;

  StreamSubscription? _conversationSubscription;

  ConversationsViewModel() {
    requestUserConversation();
    listenToConversationStream();
  }

  void listenToConversationStream() {
    _setLoading(true);
    _conversationSubscription?.cancel();
    _conversationSubscription = _conversationRepo.userConversation.listen(
      (newConversations) {
        _conversations = newConversations;
        _setError(null);
        _setLoading(false);
      },
      onError: (error) {
        _setError("Failed to get conversations : ${error.toString()}");
        _setLoading(false);
      },
    );
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

  void requestUserConversation() {
    if (_authRepo.currentUser != null) {
      _conversationRepo.requestUserConversations(_authRepo.currentUser!.id);
    }
  }

  List<Conversation> get userConversations => _conversations;
}
