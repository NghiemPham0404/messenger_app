import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';
import 'package:pulse_chat/features/media/domain/entity/file_upload.dart';
import 'package:pulse_chat/features/media/domain/entity/image_upload.dart';

abstract class MediaFileRepo {
  Future<ObjectResponse<ImageUploaded>> uploadImage(XFile image);
  Future<ObjectResponse<FileUploaded>> uploadFile(XFile file);
  Future<String?> checkIfExist(String url);
  Future<String> downloadMediaFile(
    FileMetadata fileMetadata,
    Function(int, int) onProgress,
  );
}
