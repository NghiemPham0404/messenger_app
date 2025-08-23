import 'dart:io';

import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_input_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/components/file_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatInputArea extends StatefulWidget {
  const ChatInputArea({super.key});

  @override
  State<StatefulWidget> createState() {
    return MessageInputAreaState();
  }
}

class MessageInputAreaState extends State<ChatInputArea> {
  late final TextEditingController _messageContentController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool contentEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatInputNotifier>(
      builder: (context, notifier, child) {
        return Column(
          children: [
            if (notifier.isPickedImages) getPickImages(notifier),
            if (notifier.isPickedFiles) _getPickFiles(notifier),
            getInputArea(context, notifier),
          ],
        );
      },
    );
  }

  Widget getInputArea(BuildContext context, ChatInputNotifier viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          if (!viewModel.isPickedImages && !viewModel.isPickedFiles)
            _getPickImageButton(context, viewModel),
          if (!viewModel.isPickedFiles && !viewModel.isPickedImages)
            _getPickFileButton(context, viewModel),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                textCapitalization: TextCapitalization.sentences,
                placeholder: "Aa",
                controller: _messageContentController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                placeholderStyle: TextStyle(color: Colors.grey),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                suffix: IconButton(
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {},
                ),
                onChanged: (value) => validateEmptyContent(viewModel),
              ),
            ),
          ),
          getSendButton(viewModel),
        ],
      ),
    );
  }

  Widget getPickImages(ChatInputNotifier viewModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "Selected images (${viewModel.currentPickedImageFiles?.length ?? 0})",
              textAlign: TextAlign.end,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 15,
              children: List.generate(
                viewModel.currentPickedImageFiles?.length ?? 0,
                (index) => SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(
                              viewModel.currentPickedImageFiles![index].path,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeImage(viewModel, index),
                        child: Align(
                          alignment: AlignmentGeometry.xy(1.5, -1.5),
                          child: Icon(
                            Icons.cancel,
                            size: 24,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPickFiles(ChatInputNotifier viewModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "Selected files (${viewModel.currentPickedFiles?.length ?? 0})",
              textAlign: TextAlign.end,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 15,
              children: List.generate(
                viewModel.currentPickedFiles?.length ?? 0,
                (index) => SizedBox(
                  width: 150,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            getFileIconAsset(
                              viewModel.currentPickedFiles![index].name
                                  .split(".")
                                  .last,
                              fileName:
                                  viewModel.currentPickedFiles![index].name,
                            ),
                            Expanded(
                              child: Text(
                                viewModel.currentPickedFiles![index].name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeFiles(viewModel, index),
                        child: Align(
                          alignment: AlignmentGeometry.xy(1, -1),
                          child: Icon(
                            Icons.cancel,
                            size: 24,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateEmptyContent(ChatInputNotifier viewModel) {
    if (_messageContentController.text.trim().isEmpty &&
        !viewModel.isPickedImages &&
        !viewModel.isPickedFiles) {
      setState(() {
        contentEmpty = true;
      });
    } else {
      setState(() {
        contentEmpty = false;
      });
    }
  }

  Widget getSendButton(ChatInputNotifier viewModel) {
    return contentEmpty
        ? IconButton(
          icon: Icon(Icons.thumb_up, color: Theme.of(context).primaryColorDark),
          onPressed: () => sendDefaultReaction(viewModel),
        )
        : IconButton(
          icon: Icon(Icons.send, color: Theme.of(context).primaryColorDark),
          onPressed: () => sendMessage(viewModel),
        );
  }

  Widget _getPickImageButton(
    BuildContext context,
    ChatInputNotifier viewModel,
  ) {
    return IconButton(
      icon: Icon(
        Icons.image_outlined,
        color: Theme.of(context).primaryColorDark,
      ),
      onPressed: () => _pickImages(viewModel),
    );
  }

  Future<void> _pickImages(ChatInputNotifier viewModel) async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      viewModel.displayPickedImages(pickedImages);
    }
    validateEmptyContent(viewModel);
  }

  void _removeImage(ChatInputNotifier viewModel, int index) {
    viewModel.removePickedImage(index);
    validateEmptyContent(viewModel);
  }

  void sendDefaultReaction(ChatInputNotifier viewModel) {
    viewModel.requestSendMessage(text: "👍");
  }

  void sendMessage(ChatInputNotifier viewModel) async {
    final textContent =
        _messageContentController.text.isEmpty
            ? null
            : _messageContentController.text;

    // validate empty content
    if (textContent == null &&
        viewModel.currentPickedImageFiles == null &&
        viewModel.currentPickedFiles == null) {
      return;
    }
    _messageContentController.clear();
    if (textContent != null || viewModel.currentPickedImageFiles != null) {
      viewModel.requestSendMessage(text: textContent);
    }
    viewModel.sendFilesToServer();
    validateEmptyContent(viewModel);
  }

  _getPickFileButton(BuildContext context, ChatInputNotifier viewModel) {
    return IconButton(
      icon: Icon(Icons.attach_file, color: Theme.of(context).primaryColorDark),
      onPressed: () => _pickFiles(viewModel),
    );
  }

  void _pickFiles(ChatInputNotifier viewModel) async {
    final results = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (results != null) {
      viewModel.displayPickedFiles(results.xFiles);
    }
    validateEmptyContent(viewModel);
  }

  void _removeFiles(ChatInputNotifier viewModel, int index) async {
    viewModel.removePickedFiles(index);
    validateEmptyContent(viewModel);
  }

  @override
  void dispose() {
    _messageContentController.dispose();
    super.dispose();
  }
}
