import 'package:flutter/material.dart';

class GirliesDelivery extends StatefulWidget {
  @override
  _GirliesDeliveryState createState() => _GirliesDeliveryState();
}

class _GirliesDeliveryState extends State<GirliesDelivery> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Direcciones"),
        centerTitle: false,
      ),
      body: new Center(
        child: new Text(
          "No hay direcciones almacenadas.",
          style: new TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
