import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/media/data/datasource/local/media_file_local.dart';
import 'package:pulse_chat/features/media/data/datasource/network/media_file_api.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';
import 'package:pulse_chat/features/media/domain/entity/file_upload.dart';
import 'package:pulse_chat/features/media/domain/entity/image_upload.dart';
import 'package:pulse_chat/features/media/domain/repository/media_file_repo.dart';

class MediaFileRepoImpl implements MediaFileRepo {
  final MediaFileApiSource _mediaFileApiSource;
  final MediaFileLocalSource _mediaFileLocalSource;

  MediaFileRepoImpl({
    required MediaFileApiSource mediaFileApiSource,
    required MediaFileLocalSource fileLocalSource,
  }) : _mediaFileApiSource = mediaFileApiSource,
       _mediaFileLocalSource = fileLocalSource;

  @override
  Future<String?> checkIfExist(String url) async {
    return _mediaFileLocalSource.checkIfExist(url);
  }

  @override
  Future<String> downloadMediaFile(
    FileMetadata fileMetadata,
    Function(int p1, int p2) onProgress,
  ) async {
    final check = await _mediaFileLocalSource.checkIfExist(fileMetadata.url);
    if (check != null) {
      return check;
    }
    return _mediaFileLocalSource.downloadFile(fileMetadata, onProgress);
  }

  @override
  Future<ObjectResponse<FileUploaded>> uploadFile(XFile file) async {
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

    // upload file
    final res = await _mediaFileApiSource.postFile(formData);
    // save file path
    _mediaFileLocalSource.saveTheSavePathInHive(res.result.fileUrl, file.path);

    return res;
  }

  @override
  Future<ObjectResponse<ImageUploaded>> uploadImage(XFile image) async {
    final fileName = image.name;

    final mediaType = DioMediaType.parse(image.mimeType ?? 'image/jpeg');

    final multipartFile = await MultipartFile.fromFile(
      image.path,
      filename: fileName,
      contentType: mediaType,
    );

    final formData = FormData.fromMap({'image': multipartFile});

    // upload file
    final res = await _mediaFileApiSource.postImage(formData);
    // save file path
    _mediaFileLocalSource.saveTheSavePathInHive(
      res.result.imageUrl,
      image.path,
    );

    return res;
  }
}
