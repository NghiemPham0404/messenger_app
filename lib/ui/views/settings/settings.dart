import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget{

  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : const SettingsPage()
      ),
    );
  }
  
}

class SettingsPage extends StatefulWidget{

  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
  
}

class SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}