import 'package:chatting_app/data/models/upload_file_model.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

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
