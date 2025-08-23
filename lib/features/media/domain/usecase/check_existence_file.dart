import 'package:pulse_chat/features/media/domain/repository/media_file_repo.dart';

class CheckExistenceFile {
  final MediaFileRepo _mediaFileRepo;

  CheckExistenceFile({required MediaFileRepo mediaFileRepo})
    : _mediaFileRepo = mediaFileRepo;

  Future<String?> call(String networkUrl) {
    return _mediaFileRepo.checkIfExist(networkUrl);
  }
}
