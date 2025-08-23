import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';
import 'package:pulse_chat/features/media/domain/usecase/download_media_file.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_history_notifier.dart';

class ChatDownloadNotifier extends ChangeNotifier {
  //Dependency
  final ChatHistoryNotifier _chatHistoryNotifier;

  final DownloadMediaFile _downloadMediaFile;

  ChatDownloadNotifier({
    required ChatHistoryNotifier chatHistoryNotifier,
    required DownloadMediaFile downloadMediaFile,
  }) : _chatHistoryNotifier = chatHistoryNotifier,
       _downloadMediaFile = downloadMediaFile;

  //Functions
  Future<void> downloadFile(int index) async {
    FileMetadata file = _chatHistoryNotifier.messages[index].file!;

    _chatHistoryNotifier.messages[index].file?.isDownloading = true;
    try {
      String localUrl = await _downloadMediaFile(file, (received, total) {
        if (total != -1) {
          var progress = received / total;
          file.progress = progress;
          notifyListeners();
        }
      });
      file.localUrl = localUrl;
    } on DioException catch (e) {
      debugPrint('Download error: $e');
      _chatHistoryNotifier.setError("Error has occured, please try again");
    } catch (e) {
      debugPrint('Download error: $e');
      _chatHistoryNotifier.setError("Error has occured, please try again");
    } finally {
      _chatHistoryNotifier.messages[index].file?.isDownloading = false;
      notifyListeners();
    }
  }
}
