// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'chat_view_model.dart';

extension FileUpload on ChatViewModel {
  void displayPickedFiles(List<XFile>? files) {
    if (files == null) return;
    _isPickedFiles = true;
    _currentPickedFiles = files;
    notifyListeners();
  }

  void sendFilesToServer() async {
    if (_currentPickedFiles == null) return;

    _isPickedFiles = false;

    List<Future> uploadTasks =
        _currentPickedFiles!.map((file) async {
          // display sending file placeholder
          String currentTimeIsoString = toIsoStringWithLocal(
            DateTime.now().add(Duration(milliseconds: Random().nextInt(1000))),
          );
          final fileMetadata = FileMetadata(
            url: file.path,
            name: file.name,
            format: file.name.split('.').last,
            size: 0,
          );
          displaySenddingMessage(currentTimeIsoString, file: fileMetadata);

          // upload file to server first
          final uploadFile = await _mediaFileRepo.postFileToServer(file);
          if (uploadFile.result != null) {
            var originalName = uploadFile.result!.originalName ?? "unknown";
            var format = uploadFile.result!.format ?? "bin";
            var saveName = "$originalName.$format";
            FileMetadata fileMetadata = FileMetadata(
              url: uploadFile.result!.fileUrl,
              name: saveName,
              format: uploadFile.result!.format!,
              size: uploadFile.result!.size!,
              localUrl: file.path,
            );

            // then record the user message into database
            sendMessage(currentTimeIsoString, file: fileMetadata);
          } else {
            // display error if send file to server unsucessfully
            updateErrorMessage("temp-$currentTimeIsoString");
          }
        }).toList();

    await Future.wait(uploadTasks);

    clearPickedFiles();
  }

  void removePickedFiles(int index) {
    if (_currentPickedFiles == null ||
        index > _currentPickedFiles!.length - 1) {
      return;
    }
    _currentPickedFiles!.removeAt(index);
    if (_currentPickedFiles!.isEmpty) {
      clearPickedFiles();
    }
    notifyListeners();
  }

  void clearPickedFiles() {
    _currentPickedFiles = null;
    _isPickedFiles = false;
    notifyListeners();
  }
}
