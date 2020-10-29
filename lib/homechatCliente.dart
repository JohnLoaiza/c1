import 'package:conectcarga/chat_screenCliente.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomePageChatC extends StatelessWidget {
  HomePageChatC(this.id);
  String id;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: new Text("(Chat)"+id),
        ),
        body: new ChatScreenC(id));
  }
}
