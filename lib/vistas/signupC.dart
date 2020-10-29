import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:conectcarga/vistas/my_tripsCliente.dart';
import 'package:conectcarga/vistas/serviceswidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conectcarga/tools/app_data.dart';
//import 'package:flutter_girlies_store/tools/app_methods.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'perfilConductor.dart';
import 'serviceswidgetC.dart';
import 'package:conectcarga/MyPreferences.dart';

class SignUpC extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
  String _name = '';
}

class _SignUpState extends State<SignUpC> {
  MyPreferences _myPreferences = MyPreferences();

  TextEditingController fullname = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController re_password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;



  // AppMethods appMethod = new FirebaseMethods();
  var selectedValue;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF) ,
      appBar: new AppBar(
        title: new Text("Registro Clientes"),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[

            _appIcon(),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3, color: Colors.grey)
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child:  TextFormField(
                textAlign: TextAlign.right,
                controller: fullname,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(),

                ),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3, color: Colors.grey)
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child:  TextFormField(
                textAlign: TextAlign.right,
                controller: phoneNumber,
                onChanged: (value) {
                  _myPreferences.number = value;
                  _myPreferences.commit();
                },
                decoration: InputDecoration(
                  labelText: 'Numero de telefono',
                  labelStyle: TextStyle(),

                ),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3, color: Colors.grey)
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child:  TextFormField(

                textAlign: TextAlign.right,
                controller: email,
                onChanged: (value) {
                  _myPreferences.email = value;
                  _myPreferences.commit();
                },
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(),
                ),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3, color: Colors.grey)
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child:  TextFormField(
                obscureText: true,
                textAlign: TextAlign.right,
                controller: password,
                onChanged: (value) {
                  _myPreferences.password = value;
                  _myPreferences.commit();
                },
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(),
                ),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3, color: Colors.grey)
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child:  TextFormField(
                obscureText: true,
                textAlign: TextAlign.right,
                controller: re_password,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña',
                  labelStyle: TextStyle(),
                ),
              ),
            ),
            /* Container(
              //alignment: Alignment.center,
              margin: EdgeInsets.only(left: 36, top: 8),
              child:Center(
                child:
              _tipoVehiculoContainer(),
              ),
            ),*/

            appButton(
                btnTxt: "Crear Cuenta",
                onBtnclicked: verifyDetails,
                btnPadding: 20.0,
                btnColor: Color(0xFFFFFFFF)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              height: 40,
              width: 300,

              child:  RaisedButton(

                color: Colors.green,
                child: Text("Adjuntar archivos necesarios para ser generador de conectcarga", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                onPressed: (){
                  _launchURL2();
                },
              ),

            )
          ],
        ),
      ),
    );
  }

  Widget _appIcon() {
    String _name;
    return new Container(
      decoration: new BoxDecoration(color: Colors.transparent),
      child: new Image(
        image: new AssetImage("assets/images/conectcarga.png"),
        height: 130.0,
        width: 130.0,
      ),
      margin: EdgeInsets.only(top: 20.0),
    );
  }








  createDropdownItem(String code) {
    return DropdownMenuItem(
      value: code,
      child: Text(code),
    );
  }

  verifyDetails() async {


    if (fullname.text == "") {
      showSnackBar("Por favor ingresa el nombre", scaffoldKey);
      return;
    }

    if (phoneNumber.text == "") {
      showSnackBar("Debes proporcionar un número de telefono", scaffoldKey);
      return;
    }

    if (email.text == "") {
      showSnackBar("El E-mail es requerido", scaffoldKey);
      return;
    }

    if (password.text == "") {
      showSnackBar("La clave no puede estar vacia", scaffoldKey);
      return;
    }

    if (re_password.text == "") {
      showSnackBar("Por favor confirma la clave", scaffoldKey);
      return;
    }

    if (password.text != re_password.text) {
      showSnackBar("Las claves no coinciden.", scaffoldKey);
      return;
    }



    displayProgressDialog(context);


    var emai=email.text;
    var pase=password.text;
    var fullnamer=fullname.text;
    var telefon=phoneNumber.text;
    //var tipoV=selectedValue.toString();
    final response = await http.post("https://pd.domicompras.com/registroUser",
        body:{"email":"$emai","pass":"$pase","tipo":"Cliente","nombre":"$fullnamer","telefono":"$telefon","tipoVehiculo":"Cliente"});
    log("response registro clientes:  ");
    log(response.body);
    var jsonRespon=json.decode(response.body);

    if (jsonRespon['ID']>0) {
      closeProgressDialog(context);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) =>  new OrdenesList()));
    } else {
      closeProgressDialog(context);
      showSnackBar(response.body, scaffoldKey);
    }


  }
  @override
  void initState() {
    super.initState();
    _myPreferences.init().then((value) {
      setState(() {
        _myPreferences = value;
      });
    });
  }
}

_launchURL2() async {
  String fin = '.pdf';
  const url = 'https://docs.google.com/forms/d/e/1FAIpQLSc3ayJkUxyU0qB7G3H5f0K15pz1N4cKIFNoG9k4wn8KGAx0Gw/viewform?usp=sf_link';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw url;
  }
}
