import 'package:flutter/material.dart';

class GirliesAboutUs extends StatefulWidget {
  @override
  _GirliesAboutUsState createState() => _GirliesAboutUsState();
}

class _GirliesAboutUsState extends State<GirliesAboutUs> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Acerca de "),
        centerTitle: false,
      ),
      body: new Center(
        child: new Text(
          "Acerca de Conectcarga",
          style: new TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }
}
