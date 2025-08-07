import 'dart:io';

import 'package:pulse_chat/data/models/group.dart';
import 'package:pulse_chat/ui/view_models/contact_view_model.dart';
import 'package:pulse_chat/ui/view_models/group_detail_view_model.dart';
import 'package:pulse_chat/ui/view_models/group_view_model.dart';
import 'package:pulse_chat/ui/view_models/search_view_model.dart';
import 'package:pulse_chat/ui/views/group/group_detail_screen.dart';
import 'package:pulse_chat/ui/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GroupCreateScreen extends StatefulWidget {
  const GroupCreateScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return GroupCreateDialogState();
  }
}

class GroupCreateDialogState extends State<GroupCreateScreen> {
  ImagePicker _imagePicker = ImagePicker();
  late TextEditingController _groupNameEditingController;
  late TextEditingController _searchTextEditingController;

  @override
  void initState() {
    super.initState();
    _groupNameEditingController = TextEditingController();
    _searchTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ContactViewModel, GroupViewModel, SearchViewModel>(
      builder:
          (context, contactVM, groupVM, searchVM, child) =>
              CupertinoPageScaffold(
                child: SafeArea(
                  child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => createGroup(groupVM),
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.arrow_forward),
                    ),
                    body: buildBody(context, contactVM, groupVM, searchVM),
                  ),
                ),
              ),
    );
  }

  Widget buildBody(
    BuildContext context,
    ContactViewModel contactVM,
    GroupViewModel groupVM,
    SearchViewModel searchVM,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5,
        children: [
          _groupNameTextField(groupVM),
          _searchUsertextField(searchVM),
          _groupMemberSelections(contactVM, groupVM, searchVM),
          _seletedGroupMembers(groupVM),
        ],
      ),
    );
  }

  Widget _groupNameTextField(GroupViewModel groupViewModel) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            groupViewModel.clearCreateGroupData();
          },
        ),
        Expanded(
          child: TextField(
            controller: _groupNameEditingController,
            decoration: InputDecoration(hint: Text("New Group")),
          ),
        ),
        _chooseImageWidget(groupViewModel),
      ],
    );
  }

  Widget _searchUsertextField(SearchViewModel searchVM) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        hint: Text("Search user by name"),
        prefixIcon: Icon(Icons.search),
      ),
      controller: _searchTextEditingController,
      onChanged: (value) {
        searchVM.fetchUsers(value);
      },
    );
  }

  void chooseImage(GroupViewModel groupVM) async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    groupVM.selectAvatarImage(pickedImage);
  }

  Widget _chooseImageWidget(GroupViewModel groupVM) {
    return groupVM.choosenAvatar == null
        ? Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            onPressed: () => chooseImage(groupVM),
            icon: Icon(Icons.image),
          ),
        )
        : Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.file(File(groupVM.choosenAvatar!.path)),
          ),
        );
  }

  Widget _groupMemberSelections(
    ContactViewModel contactVM,
    GroupViewModel groupVM,
    SearchViewModel searchVM,
  ) {
    return _searchTextEditingController.text.isEmpty
        ? _contactSelections(groupVM, contactVM)
        : _searchSelections(groupVM, searchVM);
  }

  Widget _contactSelections(
    GroupViewModel groupVM,
    ContactViewModel contactVM,
  ) {
    final friends = contactVM.friendList?.results;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(friends?.length ?? 0, (index) {
            var user = friends?[index].otherUser;

            var selected =
                (groupVM.groupInitialUser?.indexWhere(
                      (element) => element.id == user!.id,
                    ) ??
                    -1) >
                -1;
            return Row(
              spacing: 5,
              children: [
                getAvatar(user?.avatar),
                Expanded(child: Text(user?.name ?? "Unknown")),
                Checkbox(
                  value: selected,
                  onChanged: (value) {
                    if (selected) {
                      groupVM.removeMemberSelection(user!.id);
                    } else {
                      groupVM.addMemberSelection(user!.id, user.avatar);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _searchSelections(GroupViewModel groupVM, SearchViewModel searchVM) {
    final searchedUsers = searchVM.users;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(searchedUsers.length, (index) {
            var user = searchedUsers[index];

            var selected =
                (groupVM.groupInitialUser?.indexWhere(
                      (element) => element.id == user.id,
                    ) ??
                    -1) >
                -1;

            return Row(
              spacing: 5,
              children: [
                getAvatar(user.avatar),
                Expanded(child: Text(user.name)),
                Checkbox(
                  value: selected,
                  onChanged: (value) {
                    if (value! == true) {
                      groupVM.addMemberSelection(
                        searchedUsers[index].id,
                        searchedUsers[index].avatar,
                      );
                    } else {
                      groupVM.removeMemberSelection(searchedUsers[index].id);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _seletedGroupMembers(GroupViewModel groupVM) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5,
              children: List.generate(groupVM.groupInitialUser?.length ?? 0, (
                index,
              ) {
                return GestureDetector(
                  onTap:
                      () => groupVM.removeMemberSelection(
                        groupVM.groupInitialUser![index].id,
                      ),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: getAvatar(groupVM.groupInitialUser?[index].avatar),
                  ),
                );
              }),
            ),
          ),
        ),
        Text("Selected Users (${groupVM.groupInitialUser?.length ?? 0})"),
      ],
    );
  }

  String? validateGroupDetail(GroupViewModel groupVM) {
    if (groupVM.groupInitialUser == null) {
      return "Group members can't be empty";
    }

    if (groupVM.groupInitialUser!.length < 2) {
      return "Group members must be atleast 3 users";
    }

    if (_groupNameEditingController.text.isEmpty ||
        _groupNameEditingController.text.length < 2) {
      return "Group name can't be null";
    }

    return null;
  }

  void createGroup(GroupViewModel groupVM) async {
    final SnackBar snackBar;
    String? invalidMessage = validateGroupDetail(groupVM);
    if (invalidMessage != null) {
      snackBar = SnackBar(content: Text(invalidMessage));
    } else {
      final group = await groupVM.createNewGroup(
        _groupNameEditingController.text,
      );
      if (group == null) {
        snackBar = SnackBar(
          content: Text("Group created unsuccessfully, please try again"),
        );
      } else {
        groupVM.clearCreateGroupData();
        snackBar = SnackBar(content: Text("Group created successfully"));
        navigateToDetailScreen(group);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetailScreen(Group group) {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder:
            (context) => ChangeNotifierProvider(
              create: (_) => GroupDetailViewModel(group),
              child: GroupDetailScreen(),
            ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _groupNameEditingController.dispose();
  }
}
