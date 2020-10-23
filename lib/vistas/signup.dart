import 'dart:convert';
import 'dart:developer';
import 'package:conectcarga/MyPreferences.dart';
import 'package:conectcarga/vistas/my_trips2.dart';

import 'perfilConductor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:http/http.dart' as http;
import 'my_trips.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'serviceswidget.dart';
import 'package:url_launcher/url_launcher.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  MyPreferences _myPreferences = MyPreferences();
  String fullnamer = "";
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
        title: new Text("Registro Conductores"),
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
                textAlign: TextAlign.center,
                controller: fullname,
                onChanged: (value) {
                  _myPreferences.name = value;
                  _myPreferences.commit();
                },
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
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
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
                controller: re_password,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña',
                  labelStyle: TextStyle(),

                ),
              ),
            ),
            new SizedBox(
              height: 10.0,
            ),
            Container(
              //alignment: Alignment.center,
              margin: EdgeInsets.only(left: 36, top: 8),
              child:Center(
                child:
              _tipoVehiculoContainer(),
              ),
            ),

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
                child: Text("Adjuntar archivos necesarios para ser conductor de conectcarga", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                onPressed: (){
                  _launchURL2();
                  },
              ),
            
            )],
        ),
      ),
    );
  }


  
  

  Widget _appIcon() {
    return new Container(
      decoration: new BoxDecoration(color: Colors.transparent),
      child: new Image(
        image: new AssetImage("assets/images/conectcarga.png"),
        height: 110.0,
        width: 110.0,
      ),
      margin: EdgeInsets.only(top: 10.0),
    );
  }



  Widget _tipoVehiculoContainer(){

    return new  Container(
        margin: EdgeInsets.only(right: 14, left: 0),
        child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  padding: EdgeInsets.only(
                      left: 0, right: 8, top: 4, bottom: 4),
                  child: Icon(Icons.local_shipping)),

              Container(

                  padding: EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),

                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(6)),
                      border:
                      Border.all(color: Colors.grey.shade400),

                  ),
                  child: DropdownButton(

                      items: createCountryCodeList(),

                      onChanged: (change) {
                        setState(() {
                          this.selectedValue = change;
                        });
                      },
                      //icon: Icon(Icons.local_shipping),
                      value: this.selectedValue,
                     isDense: true,
                      //isExpanded: false,
                      hint:Text("Tipo de Vehiculo")
                  ),
                  //margin: EdgeInsets.only(bottom: 5.0)
              ),

              SizedBox(
                width: 8,
              ),

            ]
        )
    );

  }


  createCountryCodeList() {
    List<DropdownMenuItem<String>> TipoVehiculos = new List();
    TipoVehiculos.add(createDropdownItem("Vehiculo Turbo"));
    TipoVehiculos.add(createDropdownItem("Camión Sencillo"));
    TipoVehiculos.add(createDropdownItem("Doble Troque"));
    TipoVehiculos.add(createDropdownItem("Cuatro Manos"));
    TipoVehiculos.add(createDropdownItem("Mini Mula"));
    TipoVehiculos.add(createDropdownItem("TractoMula 2 Troques"));
    TipoVehiculos.add(createDropdownItem("TractoMula 3 Troques"));

    return TipoVehiculos;
  }


  createDropdownItem(String code) {
    return DropdownMenuItem(
      value: code,
      child: Text(code),
    );
  }

 verifyDetails() async {
   var preferences = SharedPreferencesHelper();
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

    if (selectedValue.toString() == "") {
      showSnackBar("Por favor seleccione el tipo de vehiculo.", scaffoldKey);
      return;
    }
    displayProgressDialog(context);
    preferences.setNombre(fullname.text);
    setState((){
      fullnamer=fullname.text;
    });

    var emai=email.text;
    var pase=password.text;

    var telefon=phoneNumber.text;
    var tipoV=selectedValue.toString();
    final response = await http.post("https://pd.domicompras.com/registroUser",
        body:{"email":"$emai","pass":"$pase","tipo":"conductor","nombre":"$fullnamer","telefono":"$telefon","tipoVehiculo":"$tipoV"});
    log("response login:  ");
    log(response.body);
    var jsonRespon=json.decode(response.body);

    if (jsonRespon['ID']>0) {
      closeProgressDialog(context);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) =>  new UserList()));

    } else {
      closeProgressDialog(context);
      showSnackBar(response.body, scaffoldKey);
    }


  }
}




class WebviewFlutter extends StatelessWidget {
    WebViewController _controller;
    WebviewFlutter({Key key}) : super(key: key);
    
    _back() async {
      if (await _controller.canGoBack()) {
        await _controller.goBack();
      }
    }

    _forward() async {
      if (await _controller.canGoForward()) {
        await _controller.goForward();
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Documentos para ser conductor de Conectcarga'),
          actions: <Widget>[
            IconButton(
              onPressed: _back,
              icon: Icon(Icons.arrow_back_ios),
            ),
             IconButton(
              onPressed: _forward,
              icon: Icon(Icons.arrow_forward_ios),
               ),
             ]
        ),
       body: SafeArea(
         child: WebView(
           key: Key('webview'),
           initialUrl: "https://torre.oportuna.red/complex",
           javascriptMode: JavascriptMode.unrestricted,
           onWebViewCreated: (WebViewController webViewController) {
             _controller = webViewController;
           },
         ),
       ),
      );
    }

  }/**/

_launchURL2() async {
  String fin = '.pdf';
  const url = 'https://docs.google.com/forms/d/e/1FAIpQLSemOT662zBToYYPakg0iJkSv1Ec-sCUeQnZtP7nk5YIYtfCcw/viewform?usp=sf_link';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw url;
  }
}