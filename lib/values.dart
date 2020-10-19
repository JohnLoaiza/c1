import 'package:flutter/material.dart';


String appName = "Acopio la 25";
//String URL_Server="http://192.168.1.1:8080/Acopio_25/";
String URL_Server="https://ssl.emprestur.net/Acopio_25/";

Color colorGradientTop = Color(0xFF000000 );
//Color colorGradientTop = Color(0xFF558B2F );
Color colorGradientBottom = Color(0xFF000000 );

Gradient appGradient =
LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [colorGradientTop, colorGradientBottom,], stops: [0,0.7]);