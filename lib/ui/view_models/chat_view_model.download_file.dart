// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of "chat_view_model.dart";

extension FileDownloadExtend on ChatViewModel {
  Future<void> downloadFile(int index) async {
    if (index >= messages.length) return;
    FileMetadata? file = messages[index].file;
    if (file == null) return;

    messages[index].file?.isDownloading = true;
    try {
      String localUrl = await _mediaFileRepo.downloadFile(file, (
        received,
        total,
      ) {
        if (total != -1) {
          var progress = received / total;
          file.progress = progress;
          notifyListeners();
        }
      });
      file.localUrl = localUrl;
    } on DioException catch (e) {
      debugPrint('Download error: $e');
      _setError(e.message);
    } catch (e) {
      debugPrint('Download error: $e');
      _setError("Error has occured, please try again");
    } finally {
      messages[index].file?.isDownloading = false;
      notifyListeners();
    }
  }
}
