import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/media/domain/entity/image_upload.dart';
import '../repository/media_file_repo.dart';

class UploadImageFile {
  final MediaFileRepo _mediaFileRepo;

  UploadImageFile({required MediaFileRepo mediaFileRepo})
    : _mediaFileRepo = mediaFileRepo;

  Future<ObjectResponse<ImageUploaded>> call(XFile image) async {
    return _mediaFileRepo.uploadImage(image);
  }
}
