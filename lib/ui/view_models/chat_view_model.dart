import 'dart:async';
import 'dart:math';

import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/file_metadata.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/models/sender.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/conversation_repo.dart';
import 'package:chatting_app/data/repositories/media_file_repo.dart';
import 'package:chatting_app/data/repositories/message_repo.dart';
import 'package:chatting_app/ui/view_models/chat_strategy.dart';
import 'package:chatting_app/util/format_readable_date.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

part "chat_view_model.upload_images.dart";
part "chat_view_model.upload_files.dart";
part "chat_view_model.download_file.dart";

class ChatViewModel extends ChangeNotifier {
  final MessageRepo messageRepo = MessageRepo();
  final ConversationRepo _conversationRepo = ConversationRepo();
  final AuthRepo _authRepo = AuthRepo();
  final MediaFileRepo _mediaFileRepo = MediaFileRepo();

  late final ChatStrategy _chatStrategy;

  late final Conversation _conversation;
  Conversation? get conversation => _conversation;

  StreamSubscription? _messageSubscription;

  int get userId => _authRepo.currentUser!.id;
  int? groupId;
  int? otherUserId;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool _hasPre = false;
  bool get hasPre => _hasPre;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ChatViewModel(Conversation conversation) {
    _conversation = conversation;

    if (conversation.groupId != null) {
      groupId = conversation.groupId!;
      _chatStrategy = GroupChatStrategy(
        userId: userId,
        groupId: groupId!,
        conversationRepo: _conversationRepo,
        messageRepo: messageRepo,
      );
    } else if (conversation.receiverId != null) {
      otherUserId =
          (conversation.userId == userId)
              ? conversation.receiverId!
              : conversation.userId;

      _chatStrategy = DirectChatStrategy(
        userId: userId,
        receiverId: otherUserId!,
        conversationRepo: _conversationRepo,
        messageRepo: messageRepo,
      );
    } else {
      throw Exception("Invalid conversation type.");
    }
  }

  void initialize() {
    requestMessages();
  }

  void _setError(String? message) async {
    _errorMessage = message;
    notifyListeners();
    Future.delayed(Duration(seconds: 4), () async {
      _errorMessage = null;
      notifyListeners();
    });
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void requestMessages({int page = 1}) async {
    _setLoading(true);
    try {
      final response = await _chatStrategy.requestMessages(page: page);
      _currentPage = response.page ?? 0;
      _hasPre = (response.page ?? 0) < (response.totalPages ?? 0);
      if (response.page == 1) {
        _messages = response.results ?? [];
      } else {
        _messages.addAll(response.results ?? []);
      }
    } on DioException catch (e) {
      final detail = e.response?.data["detail"];
      debugPrint(detail);
    } catch (e) {
      debugPrint("$e");
    } finally {
      _setLoading(false);
    }
  }

  void requestOlderMessages() {
    if (_hasPre) {
      requestMessages(page: currentPage + 1);
    }
  }

  void requestSendMessage({String? text, FileMetadata? file}) async {
    String currentTimeIsoString = toIsoStringWithLocal(DateTime.now());

    // display fake placeholder for sending message for user experience
    displaySenddingMessage(
      currentTimeIsoString,
      text: text,
      file: file,
      images: getPickImageOriginUrls(),
    );
    _isPickedImages = false;
    final imageUrls = await getPickImageUrls();
    clearPickedImages();
    sendMessage(
      currentTimeIsoString,
      text: text,
      file: file,
      images: imageUrls,
    );
  }

  void sendMessage(
    String currentTimeIsoString, {
    String? text,
    FileMetadata? file,
    List<String>? images,
  }) async {
    final message = await _chatStrategy.sendMessage(
      userId: userId,
      timeStamp: currentTimeIsoString,
      messageContent: text,
      file: file,
      images: images,
    );

    if (message != null) {
      updateNewMessage(message);
    } else {
      updateErrorMessage("temp-$currentTimeIsoString");
      _setError("send error");
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
      groupId: groupId,
      receiverId: otherUserId,
      sender: Sender(
        _authRepo.currentUser!.id,
        _authRepo.currentUser!.name,
        _authRepo.currentUser!.avatar!,
      ),
    );
    _messages.insert(0, fakeMessage);
    notifyListeners();
  }

  void updateNewMessage(Message message) async {
    final incomingTime = DateTime.parse(message.timestamp).toUtc();

    final index = _messages.indexWhere(
      (msg) =>
          msg.id.startsWith("temp") &&
          DateTime.parse(
            msg.timestamp,
          ).toUtc().isAtSameMomentAs(incomingTime) &&
          msg.userId == message.userId,
    );

    if (index != -1) {
      _messages[index].id = message.id;
      if (_messages[index].file != null) {
        _messages[index].file?.url = message.file!.url;
      }
    } else {
      _messages.insert(0, message);
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

  void sendDirectMessage({
    required int userId,
    required int receiverId,
    required String timeStamp,
    String? messageContent,
    FileMetadata? file,
    List<String>? images,
  }) async {
    final messageCreate = DirectMessageCreate(
      receiverId: receiverId,
      userId: userId,
      timestamp: timeStamp,
      content: messageContent,
      file: file,
      images: images,
    );
    final message = await messageRepo.sendDirectMesssage(messageCreate);
    if (message != null) {
      updateNewMessage(message);
    } else {
      updateErrorMessage("temp-$timeStamp");
      _setError("send error");
    }
  }

  void sendGroupMessage({
    required int userId,
    required int groupId,
    required String timeStamp,
    String? messageContent,
    FileMetadata? file,
    List<String>? images,
  }) async {
    final groupMessageCreate = GroupMessageCreate(
      groupId: groupId,
      userId: userId,
      timestamp: timeStamp,
      content: messageContent,
      file: file,
      images: images,
    );

    final message = await messageRepo.sendGroupMessage(groupMessageCreate);
    if (message != null) {
      updateNewMessage(message);
    } else {
      updateErrorMessage("temp-$timeStamp");
      _setError("send error");
    }
  }

  void editSentMessage({
    required String messageId,
    String updateTextContent = "",
  }) async {
    try {
      final updatedMessage = MessageUpdate(content: updateTextContent);
      final message = await messageRepo.updateSentMessage(
        messageId,
        updatedMessage,
      );
      if (message == null) {
        _setError("can't update message");
      } else {
        final index = _messages.indexWhere(
          (message) => message.id == messageId,
        );
        if (index != -1) {
          _messages[index].content = message.content;
        }
      }
    } on DioException catch (e) {
      debugPrint("[Update Message] detail : ${e.response!.data["detail"]}");
      _setError(e.response!.data["detail"]);
    } catch (e) {
      debugPrint("[Update Message] detail : $e");
      _setError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  void deleteMessage(String messageId) async {
    debugPrint("[Delete Message] id = $messageId");
    try {
      final messageResponse = await messageRepo.deleteMessage(messageId);
      if (messageResponse.success) {
        final index = _messages.indexWhere(
          (message) => message.id == messageId,
        );
        _messages.removeAt(index);
      }
    } on DioException catch (e) {
      debugPrint("[Delete Message] detail : ${e.response!.data["detail"]}");
      _setError(e.response!.data["detail"]);
    } catch (e) {
      debugPrint("[Delete Message] detail : $e");
      _setError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  bool _isPickedImages = false;
  bool get isPickedImages => _isPickedImages;
  List<XFile>? _currentPickedImageFiles;
  List<XFile>? get currentPickedImageFiles => _currentPickedImageFiles;

  bool _isPickedFiles = false;
  bool get isPickedFiles => _isPickedFiles;
  List<XFile>? _currentPickedFiles;
  List<XFile>? get currentPickedFiles => _currentPickedFiles;
}
