import 'package:flutter/material.dart';

class ContactsTab extends StatelessWidget{

  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : const ContactsPage()
      ),
    );
  }
  
}

class ContactsPage extends StatefulWidget{

  const ContactsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ContactsPageState();
  }
  
}

class ContactsPageState extends State<ContactsPage>{
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(),
     );
  }
  
}