
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void _position(var contexto,var id,) async {

  await   showDialog(
      context: contexto,
      builder: (context) {
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                color: Colors.white,
                child: Text(""),
              ),
            ),
          ),

        );
      }
  );
}