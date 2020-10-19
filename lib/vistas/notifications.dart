import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GirliesNotifications extends StatefulWidget {
  @override
  _GirliesNotificationsState createState() => _GirliesNotificationsState();
}

class _GirliesNotificationsState extends State<GirliesNotifications> {

  String barcode = "";
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Notificaciones de Servicio"),
        centerTitle: false,
      ),
      body: new Center(
        child:new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('Escanear codigo')
              ),
            )
            ,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(barcode, textAlign: TextAlign.center,),
            )
            ,
          ],
        ),
      ),
    );
  }


  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancelar",
          "flash_on": "Encender Flash",
          "flash_off": "Apagar Flash",
        },
        autoEnableFlash: false,
        android: AndroidOptions(
          aspectTolerance: 2.0,
          useAutoFocus: true,
        ),
      );
      var barcode = await BarcodeScanner.scan(options: options);
      setState(() => this.barcode = barcode.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'No se han proporcionado los permisos';
        });
      } else {
        setState(() => this.barcode = 'Error desconocido: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'Error (El usuario regresó usando el botón "atrás" antes de escanear el codigo)');
    } catch (e) {
      setState(() => this.barcode = 'Error desconocido: $e');
    }
  }
}
