import 'package:chatting_app/ui/view_models/group_member_view_model.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMemberAddingScreen extends StatefulWidget {
  final int groupId;

  const GroupMemberAddingScreen({required this.groupId, super.key});

  @override
  State<StatefulWidget> createState() => GroupMemberAddingScreenState();
}

class GroupMemberAddingScreenState extends State<GroupMemberAddingScreen> {
  late final int groupId;

  late final TextEditingController _searchTextEditingController;

  @override
  void initState() {
    super.initState();

    groupId = widget.groupId;

    _searchTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupMemberViewModel>(
      builder:
          (context, groupMemberVM, child) => CupertinoPageScaffold(
            child: SafeArea(
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => confirmAdding(groupMemberVM),
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.arrow_forward),
                ),
                body: buildBody(context, groupMemberVM),
              ),
            ),
          ),
    );
  }

  Widget buildBody(BuildContext context, GroupMemberViewModel groupMemberVM) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5,
        children: [
          _searchUsertextField(),
          _groupMemberSelections(groupMemberVM),
          _seletedGroupMembers(groupMemberVM),
        ],
      ),
    );
  }

  Widget _searchUsertextField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        hint: Text("Search user by name"),
        prefixIcon: Icon(Icons.search),
      ),
      controller: _searchTextEditingController,
      onChanged: (value) {},
    );
  }

  Widget _groupMemberSelections(GroupMemberViewModel groupMemberVM) {
    return _contactSelections(groupMemberVM);
  }

  Widget _contactSelections(GroupMemberViewModel groupMemberVM) {
    final friends = groupMemberVM.friendList?.results;
    debugPrint(groupMemberVM.checkedGroupMembers.toString());

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          spacing: 5,
          children: List.generate(friends?.length ?? 0, (index) {
            var user = friends?[index].otherUser;
            if (user == null) return SizedBox();

            var selected =
                (groupMemberVM.addtionalUsers?.indexWhere(
                      (e) => e.id == user.id,
                    ) ??
                    -1) >
                -1;

            var memberStatus = groupMemberVM.checkedGroupMembers[user.id];
            if (memberStatus == null) {
              debugPrint(
                "[Group-member pre send request check] user id null = ${user.id}",
              );
            }

            Widget trailing;
            if (memberStatus == null || memberStatus.status == -1) {
              // Show checkbox for not-yet-members
              trailing = Checkbox(
                value: selected,
                onChanged: (value) {
                  if (selected) {
                    groupMemberVM.removeMemberSelection(user.id);
                  } else {
                    groupMemberVM.addMemberSelection(user.id, user.avatar);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                activeColor: Theme.of(context).primaryColor,
              );
            } else if (memberStatus.status == 0) {
              trailing = Text(
                "sent",
                style: TextStyle(color: Theme.of(context).primaryColor),
              );
            } else if (memberStatus.status == 2) {
              trailing = ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text("Accept"),
              );
            } else if (memberStatus.isHost) {
              trailing = const Text(
                "Admin",
                style: TextStyle(color: Colors.amber),
              );
            } else if (memberStatus.isSubHost) {
              trailing = const Text("Sub Host");
            } else {
              trailing = const Text("joined");
            }

            return Row(
              children: [
                getAvatar(user.avatar),
                const SizedBox(width: 8),
                Expanded(child: Text(user.name)),
                trailing,
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _seletedGroupMembers(GroupMemberViewModel groupMemberVM) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5,
              children: List.generate(
                groupMemberVM.addtionalUsers?.length ?? 0,
                (index) {
                  return GestureDetector(
                    onTap:
                        () => groupMemberVM.removeMemberSelection(
                          groupMemberVM.addtionalUsers![index].id,
                        ),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: getAvatar(
                        groupMemberVM.addtionalUsers?[index].avatar,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Text("Selected Users (${groupMemberVM.addtionalUsers?.length ?? 0})"),
      ],
    );
  }

  void confirmAdding(GroupMemberViewModel groupMemberVM) {
    groupMemberVM.confirmAddingSentRequests(groupId);
  }
}
