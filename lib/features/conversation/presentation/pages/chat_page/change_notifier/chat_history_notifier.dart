import 'dart:async';

import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/util/page_state.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';
import 'package:pulse_chat/features/media/domain/usecase/check_existence_file.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/entities/sender.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_chat_history.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChatHistoryNotifier extends ChangeNotifier {
  final LocalAuthSource _localAuthSource;

  PageState _pageState = PageState.initial;
  PageState get pageState => _pageState;

  int get userId => _localAuthSource.getCachedUser()?.id ?? 0;

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool _hasPre = false;
  bool get hasPre => _hasPre;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final GetChatHistory _getChatHistory;

  final CheckExistenceFile _checkExistenceFile;

  final int _otherId;
  int get otherId => _otherId;

  ChatHistoryNotifier({
    required GetChatHistory getChatHistory,
    required CheckExistenceFile checkExistenceFile,
    required int otherId,
    required LocalAuthSource localAuthSource,
  }) : _localAuthSource = localAuthSource,
       _getChatHistory = getChatHistory,
       _checkExistenceFile = checkExistenceFile,
       _otherId = otherId;

  void initialize() {
    requestMessages();
  }

  void setError(String? message) async {
    _pageState = PageState.error;
    _errorMessage = message;
    notifyListeners();
    Future.delayed(Duration(seconds: 4), () async {
      _errorMessage = null;
      notifyListeners();
    });
  }

  void requestMessages({int page = 1}) async {
    _pageState = PageState.loading;
    notifyListeners();
    try {
      final response = await _getChatHistory(otherId: _otherId, page: page);
      _currentPage = response.page;
      _hasPre = response.page < response.totalPages;
      await Future.wait(
        response.results.map((msg) async {
          if (msg.file != null) {
            final localPath = await _checkExistenceFile(msg.file!.url);
            msg.file?.localUrl = localPath;
          }
        }),
      );
      _messages.addAll(response.results);
    } on DioException catch (e) {
      final detail = e.response?.data["detail"];
      setError("An error has occured, try later");
      debugPrint(detail);
    } catch (e) {
      debugPrint("[Request Messages] : $e");
    } finally {
      _pageState = PageState.done;
      notifyListeners();
    }
  }

  void requestOlderMessages() {
    if (_hasPre) {
      requestMessages(page: currentPage + 1);
    }
  }

  void displaySenddingMessage(
    String currentTimeIsoString, {
    String? text,
    FileMetadata? file,
    List<String>? images,
  }) {
    // # create fake message to display faster
    final fakeMessage = Message(
      id: "temp-$currentTimeIsoString",
      timestamp: currentTimeIsoString,
      userId: userId,
      content: text,
      file: file,
      images: images,
      groupId: null,
      receiverId: null,
      sender: Sender(
        id: _localAuthSource.getCachedUser()?.id ?? 0,
        name: _localAuthSource.getCachedUser()?.name ?? "Nan",
        avatar: _localAuthSource.getCachedUser()?.avatar ?? "Nan",
      ),
    );
    _messages.insert(0, fakeMessage);
    notifyListeners();
  }

  void updateNewMessage(Message message) async {
    // update placeholder message
    final incomingTime = DateTime.parse(message.timestamp).toUtc();

    final index = _messages.indexWhere(
      (msg) =>
          msg.id.startsWith("temp") &&
          DateTime.parse(
            msg.timestamp,
          ).toUtc().isAtSameMomentAs(incomingTime) &&
          msg.userId == message.userId,
    );

    debugPrint(
      "Found : index = $index otherId = $otherId, userId = ${message.userId}, groupId = ${message.groupId}",
    );

    if (index != -1) {
      _messages[index].id = message.id;
      _messages[index].groupId = message.groupId;
      _messages[index].receiverId = message.receiverId;
      if (_messages[index].file != null) {
        _messages[index].file?.url = message.file!.url;
        _messages[index].file?.size = message.file!.size;
      }
    } else {
      if (_otherId == message.groupId || message.userId == _otherId) {
        _messages.insert(0, message);
      }
    }

    debugPrint("${_messages.length}");
    notifyListeners();
  }

  void updateErrorMessage(String id) {
    final index = _messages.indexWhere((msg) => msg.id == id);

    if (index != -1) {
      _messages[index].id = "error-${_messages[index].timestamp}";
    }

    notifyListeners();
  }
}
