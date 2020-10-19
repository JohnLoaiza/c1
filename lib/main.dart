import 'package:conectcarga/vistas/login.dart';
import 'package:flutter/material.dart';
import 'vistas/myHomePage.dart';
import 'vistas/splash_page.dart';
import 'vistas/rate.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ConectCarga',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GirliesLogin(),
      //home:new  RateMyAppTestApp(),
    );
  }
}