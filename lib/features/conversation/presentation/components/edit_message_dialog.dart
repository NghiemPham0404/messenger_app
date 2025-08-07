import 'package:flutter/material.dart';

import '../../domain/entities/message.dart';

void showEditDialog(
  BuildContext context,
  Message message,
  Function(String, String) editMessage,
) {
  final TextEditingController controller = TextEditingController(
    text: message.content,
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                5,
                16,
                5,
              ), // leave space for the button
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Edit your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final updatedText = controller.text.trim();
                      if (updatedText.isNotEmpty) {
                        editMessage(message.id, updatedText);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
