// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'chat_view_model.dart';

extension ImagesUpload on ChatViewModel {
  void displayPickedImages(List<XFile>? images) async {
    if (images == null) return;
    _currentPickedImageFiles = images;
    _isPickedImages = true;
    notifyListeners();
  }

  Future<List<String>?> getPickImageUrls() async {
    if (_currentPickedImageFiles == null) return null;

    List<Future<String?>> uploadImageUrls =
        _currentPickedImageFiles!.map((imageFile) async {
          debugPrint(
            "[image upload] image original name : ${imageFile.name.split('.')[0]}",
          );
          final response = await _mediaFileRepo.postImageToServer(imageFile);
          if (response.result == null) {
            debugPrint("[image upload] fail original path : ${imageFile.name}");
            return null;
          } else {
            return response.result!.imageUrl;
          }
        }).toList();

    // raw results, contain image urls and may contain null
    final rawImageUrls = await Future.wait(uploadImageUrls);

    // filter all null
    final imageUrls = rawImageUrls.whereType<String>().toList();

    return imageUrls.isEmpty ? null : imageUrls;
  }

  List<String>? getPickImageOriginUrls() {
    if (_currentPickedImageFiles == null) return null;
    return _currentPickedImageFiles?.map((item) => item.path).toList();
  }

  void removePickedImage(int index) {
    if (_currentPickedImageFiles == null ||
        index > _currentPickedImageFiles!.length - 1) {
      return;
    }
    _currentPickedImageFiles!.removeAt(index);
    if (_currentPickedImageFiles!.isEmpty) {
      clearPickedImages();
    }
    notifyListeners();
  }

  void clearPickedImages() {
    _currentPickedImageFiles = null;
    _isPickedImages = false;
  }
}
