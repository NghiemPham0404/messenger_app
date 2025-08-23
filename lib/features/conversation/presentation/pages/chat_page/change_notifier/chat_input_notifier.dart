import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/util/format_readable_date.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_image_file.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_media_file.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_send.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/send_message.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_history_notifier.dart';

class ChatInputNotifier extends ChangeNotifier {
  // Properties
  bool _isPickedFiles = false;
  bool get isPickedFiles => _isPickedFiles;
  List<XFile>? _currentPickedFiles;
  List<XFile>? get currentPickedFiles => _currentPickedFiles;

  // Dependecies
  final LocalAuthSource _localAuthSource;

  get userId => _localAuthSource.getCachedUser()?.id ?? 0;
  final SendMessage _sendMessage;
  final UploadMediaFile _uploadMediaFile;
  final UploadImageFile _uploadImageFile;

  final ChatHistoryNotifier _chatNotifier;

  ChatInputNotifier({
    required LocalAuthSource localAuthSource,
    required SendMessage sendMessage,
    required ChatHistoryNotifier chatNotifier,
    required UploadMediaFile uploadMediaFile,
    required UploadImageFile uploadImageFile,
  }) : _localAuthSource = localAuthSource,
       _sendMessage = sendMessage,
       _chatNotifier = chatNotifier,
       _uploadMediaFile = uploadMediaFile,
       _uploadImageFile = uploadImageFile;

  // ----------SEND MESSAGE--------------------------------------------------------------
  void requestSendMessage({String? text, FileMetadata? file}) async {
    String currentTimeIsoString = toIsoStringWithLocal(DateTime.now());

    // display fake placeholder for sending message for user experience
    _chatNotifier.displaySenddingMessage(
      currentTimeIsoString,
      text: text,
      file: file,
      images: getPickImageOriginUrls(),
    );
    // send images to server then get network urls
    _isPickedImages = false;
    final imageUrls = await getPickImageUrls();
    clearPickedImages();
    // start send message
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
    final messageSend = MessageSend(
      userId: userId,
      timestamp: currentTimeIsoString,
      content: text,
      file: file,
      images: images,
    );
    try {
      final res = await _sendMessage(_chatNotifier.otherId, messageSend);
      // hide loading indicator
      _chatNotifier.updateNewMessage(res.result);
    } catch (e) {
      // show error
      debugPrint(e.toString());
      _chatNotifier.updateErrorMessage("temp-$currentTimeIsoString");
      _chatNotifier.setError("send error");
    }
  }

  // --------PICK IMAGES------------------------------------------------------------------------
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
          try {
            final response = await _uploadImageFile(imageFile);
            return response.result.imageUrl;
          } catch (e) {
            debugPrint("[image upload] fail original path : ${imageFile.name}");
            return null;
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

  // --------PICK FILES------------------------------------------------------------------------
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
            localUrl: file.path,
          );
          _chatNotifier.displaySenddingMessage(
            currentTimeIsoString,
            file: fileMetadata,
          );

          // upload file to server first
          try {
            final uploadFile = await _uploadMediaFile(file);
            var originalName = uploadFile.result.originalName ?? "unknown";
            var format = uploadFile.result.format ?? "bin";
            var saveName = "$originalName.$format";
            FileMetadata fileMetadata = FileMetadata(
              url: uploadFile.result.fileUrl,
              name: saveName,
              format: uploadFile.result.format!,
              size: uploadFile.result.size!,
              localUrl: file.path,
            );
            // then record the user message into database
            sendMessage(currentTimeIsoString, file: fileMetadata);
          } catch (e) {
            // display error if send file to server unsucessfully
            _chatNotifier.updateErrorMessage("temp-$currentTimeIsoString");
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
