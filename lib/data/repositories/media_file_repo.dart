import 'dart:io';

import 'package:chatting_app/data/models/file_metadata.dart';
import 'package:chatting_app/data/models/upload_file_model.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaFileRepo {
  final _apiClient = ApiClient();

  MediaFileRepo.internal();

  static final _instance = MediaFileRepo.internal();

  factory MediaFileRepo() => _instance;

  Future<ObjectResponse<ImageUploaded>> postImageToServer(
    XFile imageFile,
  ) async {
    final fileName = imageFile.name;

    final mediaType = DioMediaType.parse(imageFile.mimeType ?? 'image/jpeg');

    final multipartFile = await MultipartFile.fromFile(
      imageFile.path,
      filename: fileName,
      contentType: mediaType,
    );

    final formData = FormData.fromMap({'image': multipartFile});

    return await _apiClient.mediaFileApi.postImage(formData);
  }

  Future<ObjectResponse<FileUploaded>> postFileToServer(XFile file) async {
    final fileName = file.name;

    final mediaType = DioMediaType.parse(
      file.mimeType ?? 'application/octet-stream',
    );

    final multipartFile = await MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: mediaType,
    );

    final formData = FormData.fromMap({'file': multipartFile});

    return await _apiClient.mediaFileApi.postFile(formData);
  }
}

extension DownloadFileService on MediaFileRepo {
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) return true;

      // If denied forever
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }

      return false;
    }

    return true;
  }

  Future<String> downloadFile(
    FileMetadata fileMetadata,
    Function(int, int) onProgress,
  ) async {
    final url = fileMetadata.url;
    debugPrint("[Download] url : $url");
    final Dio dio = Dio();

    if (!await requestStoragePermission()) {
      throw Exception("[Download] : Permission not granted");
    }

    final dir =
        Platform.isAndroid
            ? Directory("/storage/emulated/0/Download")
            : await getApplicationDocumentsDirectory();

    final fileName = fileMetadata.name;
    final savePath = '${dir.path}/MessengerApp/$fileName';
    debugPrint("[Download] local path : $savePath");

    await dio.download(url, savePath, onReceiveProgress: onProgress);

    return savePath;
  }
}
