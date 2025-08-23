import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../domain/entity/file_metadata.dart';

class MediaFileLocalSource {
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    }

    return true;
  }

  void saveTheSavePathInHive(String url, String savedPath) async {
    // Open Hive box
    final box = await Hive.openBox("downloads");
    // Save path in Hive
    box.put(url, savedPath);
  }

  Future<String?> checkIfExist(String url) async {
    // Open Hive box
    final box = await Hive.openBox("downloads");
    if (box.containsKey(url)) {
      final savedPath = box.get(url);
      if (savedPath != null && File(savedPath).existsSync()) {
        return savedPath;
      }
    }
    return null;
  }

  Future<String> downloadFile(
    FileMetadata fileMetadata,
    Function(int, int) onProgress,
  ) async {
    final url = fileMetadata.url;
    debugPrint("[Download] url : $url");

    // check if had been downloaded before
    final savedPath = await checkIfExist(url);
    if (savedPath != null) {
      return savedPath;
    }

    // ask permission
    if (!await requestStoragePermission()) {
      throw Exception("[Download] : Permission not granted");
    }

    // start download
    final dir =
        Platform.isAndroid
            ? Directory("/storage/emulated/0/Download")
            : await getApplicationDocumentsDirectory();

    final fileName = fileMetadata.name;
    final savePath = '${dir.path}/PulseChat/$fileName';
    debugPrint("[Download] local path : $savePath");

    final Dio dio = Dio();

    await dio.download(url, savePath, onReceiveProgress: onProgress);
    saveTheSavePathInHive(url, savePath);

    return savePath;
  }
}
