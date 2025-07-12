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
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

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

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
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
      _messages[index].content = message.content;
      _messages[index].images = message.images;
      _messages[index].file = message.file;
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

  void displayPickedImages(List<XFile>? images) async {
    if (images == null) return;
    _currentPickedImageFiles = images;
    _isPickedImages = true;
    notifyListeners();
  }

  Future<List<String>?> getPickImageUrls() async {
    if (_currentPickedImageFiles == null) return null;

    List<Future<String?>> uploadImageUrls =
        _currentPickedImageFiles!.map((imageFile) async {
          debugPrint(
            "[image upload] image original name : ${imageFile.name.split('.')[0]}",
          );
          final response = await _mediaFileRepo.postImageToServer(imageFile);
          if (response.result == null) {
            debugPrint("[image upload] fail original path : ${imageFile.name}");
            return null;
          } else {
            return response.result!.imageUrl;
          }
        }).toList();

    // raw results, contain image urls and may contain null
    final rawImageUrls = await Future.wait(uploadImageUrls);

    // filter all null
    final imageUrls = rawImageUrls.whereType<String>().toList();

    return imageUrls.isEmpty ? null : imageUrls;
  }

  List<String>? getPickImageOriginUrls() {
    if (_currentPickedImageFiles == null) return null;
    return _currentPickedImageFiles?.map((item) => item.path).toList();
  }

  void removePickedImage(int index) {
    if (_currentPickedImageFiles == null ||
        index > _currentPickedImageFiles!.length - 1) {
      return;
    }
    _currentPickedImageFiles!.removeAt(index);
    if (_currentPickedImageFiles!.isEmpty) {
      clearPickedImages();
    }
    notifyListeners();
  }

  void clearPickedImages() {
    _currentPickedImageFiles = null;
    _isPickedImages = false;
  }

  bool _isPickedFiles = false;
  bool get isPickedFiles => _isPickedFiles;
  List<XFile>? _currentPickedFiles;
  List<XFile>? get currentPickedFiles => _currentPickedFiles;

  void displayPickedFiles(List<XFile>? files) {
    if (files == null) return;
    _isPickedFiles = true;
    _currentPickedFiles = files;
    notifyListeners();
  }

  void sendFilesToServer() async {
    if (_currentPickedFiles == null) return;

    _isPickedFiles = false;

    List<Future> uploadTasks =
        _currentPickedFiles!.map((file) async {
          // display sending file placeholder
          String currentTimeIsoString = toIsoStringWithLocal(
            DateTime.now().add(Duration(milliseconds: Random().nextInt(1000))),
          );
          final fileMetadata = FileMetadata(
            url: file.path,
            name: file.name,
            format: file.name.split('.').last,
            size: 0,
          );
          displaySenddingMessage(currentTimeIsoString, file: fileMetadata);

          // upload file to server first
          final uploadFile = await _mediaFileRepo.postFileToServer(file);
          if (uploadFile.result != null) {
            var originalName = uploadFile.result!.originalName ?? "unknown";
            var format = uploadFile.result!.format ?? "bin";
            var saveName = "$originalName.$format";
            FileMetadata fileMetadata = FileMetadata(
              url: uploadFile.result!.fileUrl,
              name: saveName,
              format: uploadFile.result!.format!,
              size: uploadFile.result!.size!,
            );

            // then record the user message into database
            sendMessage(currentTimeIsoString, file: fileMetadata);
          } else {
            // display error if send file to server unsucessfully
            updateErrorMessage("temp-$currentTimeIsoString");
          }
        }).toList();

    await Future.wait(uploadTasks);

    clearPickedFiles();
  }

  void removePickedFiles(int index) {
    if (_currentPickedFiles == null ||
        index > _currentPickedFiles!.length - 1) {
      return;
    }
    _currentPickedFiles!.removeAt(index);
    if (_currentPickedFiles!.isEmpty) {
      clearPickedFiles();
    }
    notifyListeners();
  }

  void clearPickedFiles() {
    _currentPickedFiles = null;
    _isPickedFiles = false;
    notifyListeners();
  }
}
