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

  late final Conversation _conversation;
  Conversation? get conversation => _conversation;

  StreamSubscription? _messageSubscription;

  int get userId => _authRepo.currentUser!.id;
  int? groupId;
  int? otherUserId;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ChatViewModel(Conversation conversation) {
    _conversation = conversation;
    if (conversation.groupId != null) {
      groupId = conversation.groupId!;
    }

    if (conversation.receiverId != null) {
      otherUserId =
          (conversation.userId == userId)
              ? conversation.receiverId!
              : conversation.userId;
    }
  }

  void initialize() {
    // 1. Start listening to the stream for incoming messages
    _listenToMessageStream();

    // 2. Request the initial batch of messages for the specific conversation
    requestMessages();
  }

  void _listenToMessageStream() {
    _setLoading(true);
    _messageSubscription?.cancel();
    _messageSubscription = _conversationRepo.conversationMessage.listen(
      (newMessage) {
        _messages = newMessage;
        _setLoading(false);
        _setError(null);
      },
      onError: (error) {
        _setError("[Messages] : ${error.toString()}");
        _setLoading(false);
      },
    );
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

  void requestMessages() {
    _setLoading(true);
    if (otherUserId != null) {
      _conversationRepo.requestDirectConversation(
        userId: userId,
        otherUserId: otherUserId!,
      );
    }
    if (groupId != null) {
      _conversationRepo.requestGroupConversation(groupId: groupId!);
    }
  }

  void requestOlderMessages() {
    _setLoading(true);
    if (otherUserId != null) {
      _conversationRepo.requestOlderDirectConversation(
        userId: _authRepo.currentUser!.id,
        otherUserId: otherUserId!,
      );
    }
    if (groupId != null) {
      _conversationRepo.requestOlderGroupConversation(groupId!);
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
  }) {
    if (groupId != null) {
      sendGroupMessage(
        userId: userId,
        groupId: groupId!,
        timeStamp: currentTimeIsoString,
        messageContent: text,
        file: file,
        images: images,
      );
    }
    if (otherUserId != null) {
      sendDirectMessage(
        userId: userId,
        receiverId: otherUserId!,
        timeStamp: currentTimeIsoString,
        messageContent: text,
        file: file,
        images: images,
      );
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

  Future<void> updateNewMessage(Message message) async {
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

  Future<void> sendDirectMessage({
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

  Future<void> sendGroupMessage({
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
