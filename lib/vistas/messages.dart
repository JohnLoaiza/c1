import 'package:flutter/material.dart';

class GirliesMessages extends StatefulWidget {
  @override
  _GirliesMessagesState createState() => _GirliesMessagesState();
}

class _GirliesMessagesState extends State<GirliesMessages> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mensajes"),
        centerTitle: false,
      ),
      body: new Center(
        child: new Text(
          "No hay mensajes aun.",
          style: new TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
