import 'package:chatting_app/ui/view_models/setting_view_model.dart';
import 'package:chatting_app/ui/view_models/theme_view_model.dart';
import 'package:chatting_app/ui/views/settings/theme/theme.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:chatting_app/ui/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: const SettingsPage()));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: SearchAppBar()),
          body: Consumer<SettingsViewModel>(
            builder:
                (context, settingsViewModel, child) =>
                    bodyBuilder(context, settingsViewModel),
          ),
        ),
      ),
    );
  }

  Widget bodyBuilder(BuildContext context, SettingsViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getProfileTilte(context, viewModel),
          _getSettingMenu(context, viewModel),
        ],
      ),
    );
  }

  Widget _getProfileTilte(BuildContext context, SettingsViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: getAvatar(
                viewModel.currentUser?.avatar,
                seed: viewModel.currentUser?.name,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.currentUser?.name ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("your profile"),
                  ],
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _getSettingMenu(BuildContext context, SettingsViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () => navigateToThemeSetting(context),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.color_lens_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text("Theme", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Notifications",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => logOut(context, viewModel),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Theme.of(context).primaryColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Logout", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void logOut(BuildContext context, SettingsViewModel viewModel) {
    viewModel.logOut();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void navigateToThemeSetting(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context, listen: false);

    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder:
            (context) => Provider(
              create:
                  (_) => ChangeNotifierProvider.value(value: themeViewModel),
              child: ThemeScreen(),
            ),
      ),
    );
  }
}
