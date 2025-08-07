import 'package:pulse_chat/data/models/group.dart';
import 'package:flutter/material.dart';

class EditGroupDialog extends StatefulWidget {
  final Group group;

  final Function onSave;

  const EditGroupDialog({required this.group, required this.onSave, super.key});

  @override
  State createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  late TextEditingController _subjectController;
  late bool _isPublic;
  late bool _isMemberMute;

  late final Function onSave;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.group.subject);
    _isPublic = widget.group.isPublic;
    _isMemberMute = widget.group.isMemberMute;

    onSave = widget.onSave;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Group'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject TextField
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(height: 20),

            // Visibility Radio Buttons
            Text('Visibility Status'),
            ListTile(
              title: Text('Community'),
              leading: Radio<bool>(
                value: true,
                groupValue: _isPublic,
                onChanged: (value) => setState(() => _isPublic = value!),
              ),
            ),
            ListTile(
              title: Text('Private'),
              leading: Radio<bool>(
                value: false,
                groupValue: _isPublic,
                onChanged: (value) => setState(() => _isPublic = value!),
              ),
            ),
            SizedBox(height: 20),

            // Chat Mode Radio Buttons
            Text('Chat Mode'),
            ListTile(
              title: Text('Standard'),
              leading: Radio<bool>(
                value: false,
                groupValue: _isMemberMute,
                onChanged: (value) => setState(() => _isMemberMute = value!),
              ),
            ),
            ListTile(
              title: Text('Administrator Only'),
              leading: Radio<bool>(
                value: true,
                groupValue: _isMemberMute,
                onChanged: (value) => setState(() => _isMemberMute = value!),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onSave(
              widget.group.id,
              subject: _subjectController.text,
              isPublic: _isPublic,
              isMemberMute: _isMemberMute,
            );
            Navigator.of(context).pop(); // Return updated group
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
