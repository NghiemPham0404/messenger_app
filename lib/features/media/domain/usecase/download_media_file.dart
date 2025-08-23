import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';
import 'package:pulse_chat/features/media/domain/repository/media_file_repo.dart';

class DownloadMediaFile {
  final MediaFileRepo _mediaFileRepo;

  DownloadMediaFile({required MediaFileRepo mediaFileRepo})
    : _mediaFileRepo = mediaFileRepo;

  Future<String> call(
    FileMetadata fileMetadata,
    Function(int, int) onProgress,
  ) async {
    return _mediaFileRepo.downloadMediaFile(fileMetadata, onProgress);
  }
}
