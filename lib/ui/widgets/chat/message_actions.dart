import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/ui/widgets/chat/edit_message_dialog.dart';
import 'package:flutter/material.dart';

void showMessageOptions(
  BuildContext context,
  Message message,
  Function(String) deleteMessage,
  Function(String, String) editMessage,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              confirmDelete(context, message, deleteMessage);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              showEditDialog(context, message, editMessage);
            },
          ),
        ],
      );
    },
  );
}

void confirmDelete(
  BuildContext context,
  Message message,
  Function(String) deleteMessage,
) {
  // Trigger your ViewModel's delete method here
  deleteMessage(message.id);
}
