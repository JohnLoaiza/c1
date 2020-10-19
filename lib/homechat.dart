import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomePageChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: new Text("Conectcarga (Chat)"),
        ),
        body: new ChatScreen());
  }
}
