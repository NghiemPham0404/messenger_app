import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/media/domain/entity/file_upload.dart';
import '../repository/media_file_repo.dart';

class UploadMediaFile {
  final MediaFileRepo _mediaFileRepo;

  UploadMediaFile({required MediaFileRepo mediaFileRepo})
    : _mediaFileRepo = mediaFileRepo;

  Future<ObjectResponse<FileUploaded>> call(XFile file) async {
    return _mediaFileRepo.uploadFile(file);
  }
}
