import 'package:chatting_app/ui/view_models/group_detail_view_model.dart';
import 'package:chatting_app/ui/view_models/group_member_view_model.dart';
import 'package:chatting_app/ui/views/group/group_member_screen.dart';
import 'package:chatting_app/ui/widgets/group/group_detail_edit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => GroupDetailScreenState();
}

class GroupDetailScreenState extends State<GroupDetailScreen> {
  late final ImagePicker _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupDetailViewModel>(
      builder:
          (context, groupDetailVM, child) => CupertinoPageScaffold(
            child: SafeArea(
              child: Scaffold(
                body:
                    groupDetailVM.loading
                        ? Center(child: CircularProgressIndicator())
                        : buildBody(groupDetailVM),
              ),
            ),
          ),
    );
  }

  Widget buildBody(GroupDetailViewModel groupDetailVM) {
    bool adminOrSubAdmin =
        groupDetailVM.groupMemberStatus.isHost ||
        groupDetailVM.groupMemberStatus.isSubHost;
    bool isMember = groupDetailVM.groupMemberStatus.status == 1;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getGroupMainInfo(groupDetailVM, isAdminOrSubAdmin: adminOrSubAdmin),
          SizedBox(height: 30),
          Divider(),
          if (isMember)
            _getGroupOptionsMenu(
              groupDetailVM,
              isAdminOrSubAdmin: adminOrSubAdmin,
            ),
          if (!isMember && groupDetailVM.groupMemberStatus.status == -1)
            ElevatedButton.icon(
              icon: Icon(Icons.person_add),
              onPressed:
                  () => groupDetailVM.requestJoinGroup(
                    groupDetailVM.group.id,
                    groupDetailVM.groupMemberStatus.userId,
                  ),
              label: Text("Join"),
            ),
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ],
    );
  }

  Widget _getGroupMainInfo(
    GroupDetailViewModel groupDetailVM, {
    bool isAdminOrSubAdmin = false,
  }) {
    final group = groupDetailVM.group;
    return Column(
      children: [
        _getHeader(),
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    width: 64,
                    height: 64,
                    group.avatar ??
                        "https://api.dicebear.com/9.x/initials/png?seed=${group.subject}&backgroundType=gradientLinear",
                  ),
                ),
              ),
              if (isAdminOrSubAdmin)
                Align(
                  alignment: AlignmentGeometry.xy(3, 3),
                  child: IconButton(
                    onPressed: () => _pickNewAvatar(groupDetailVM),
                    icon: Icon(Icons.camera_alt),
                  ),
                ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              group.subject,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (isAdminOrSubAdmin)
              IconButton(
                onPressed: () => _showGroupEditDialog(groupDetailVM),
                icon: Icon(Icons.edit),
              ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                " ${group.isPublic ? "Community" : "Private"} group ",
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              Icon(
                group.isPublic ? Icons.public : Icons.lock,
                color: Theme.of(context).primaryColorDark,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getGroupOptionsMenu(
    GroupDetailViewModel groupDetailVM, {
    bool isAdminOrSubAdmin = false,
  }) {
    final membersCount = groupDetailVM.group.membersCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: Icon(
            Icons.people,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            "Members ${membersCount > 0 ? '($membersCount)' : ''}",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          onTap: _navigateToMemberScreen,
        ),
        ListTile(
          leading: Icon(Icons.chat_bubble_outline_outlined),
          title: Text("join conversation"),
          onTap: () => _navigateToChatView(groupDetailVM.group.id),
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            "Leave group",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onTap: () async {
            bool result = await groupDetailVM.leaveGroup();
            if (result) {
              Navigator.pop(context);
            }
          },
        ),

        if (isAdminOrSubAdmin)
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              "Delete conversation",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _deleteGroup(groupDetailVM),
          ),
      ],
    );
  }

  void _pickNewAvatar(GroupDetailViewModel groupDetailVM) async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    groupDetailVM.updateGroupAvatar(groupDetailVM.group.id, pickedImage);
  }

  void _showGroupEditDialog(GroupDetailViewModel groupDetailVM) {
    showDialog(
      context: context,
      builder:
          (context) => EditGroupDialog(
            group: groupDetailVM.group,
            onSave: groupDetailVM.updateGroupInfo,
          ),
    );
  }

  void _deleteGroup(GroupDetailViewModel groupDetailVM) async {
    bool deleteSuccess = await groupDetailVM.deleteGroup(
      groupDetailVM.group.id,
    );

    if (deleteSuccess) {
      Navigator.of(context).pop();
      final snackBar = SnackBar(content: Text("Group deleted successfully"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _navigateToMemberScreen() {
    final groupDetailVM = Provider.of<GroupDetailViewModel>(
      context,
      listen: false,
    );
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder:
            (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => GroupMemberViewModel(groupDetailVM.group.id),
                ),
                ChangeNotifierProvider.value(value: groupDetailVM),
              ],
              child: GroupMemberScreen(),
            ),
      ),
    );
  }

  void _navigateToChatView(int groupId) {}
}
