import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomePageChat extends StatelessWidget {
  String id;
HomePageChat(this.id);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: new Text("Conectcarga (Chat)"+id),
        ),
        body: new ChatScreen(id));
  }
}
