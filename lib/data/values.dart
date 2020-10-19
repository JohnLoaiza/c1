import 'package:flutter/material.dart';


String appName = "ConetCarga";

Color colorGradientTop = Color(0xFFFFFFdd );
//Color colorGradientTop = Color(0xFF558B2F );
Color colorGradientBottom = Color(0xFFFFFFFF );

Gradient appGradient =
    LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [colorGradientTop, colorGradientBottom,], stops: [0,0.7]);