import 'dart:developer';
import 'package:conectcarga/MyPreferences.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/MyPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'my_trips2.dart';
import 'my_tripsCliente.dart';
import 'splash_page.dart';

class GirliesLogin extends StatefulWidget {
  @override
  _GirliesLoginState createState() => _GirliesLoginState();
}

class _GirliesLoginState extends State<GirliesLogin> {

  MyPreferences _myPreferences = MyPreferences();

  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  //AppMethods appMethod = new FirebaseMethods();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF) ,
      appBar: new AppBar(
        title: new Text("Login"),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new SizedBox(
              height: 30.0,
            ),
            _appIcon(),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.grey)
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
                  labelText: 'Usuario',
                  labelStyle: TextStyle(),
                ),
              ),
            ),
            new SizedBox(
              height: 30.0,
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 30, left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.grey)
              ),
              padding: EdgeInsets.only(right: 10, left: 10),
              child:  TextFormField(
                textAlign: TextAlign.center,
                obscureText: true,
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
            appButton(
                btnTxt: "Ingresar",
                onBtnclicked: verifyLoggin,
                btnPadding: 20.0,
                btnColor: Color(0xFFFFFFFF)),
            new GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new SplashPage()));
              },
              child: new Text(
                "No se ha registrado? Hagalo aquí",
                style: new TextStyle(color:Color(0xFFf39200)),
              ),
            )
          ],
        ),
      ),
    );
  }



  Widget _appIcon() {
    return new Container(
      decoration: new BoxDecoration(color: Colors.transparent),
      child: new Image(
        image: new AssetImage("assets/images/conectcarga.png"),
        height: 170.0,
        width: 170.0,
      ),
      margin: EdgeInsets.only(top: 20.0),
    );
  }

  void verifyLoggin() async {
    if (email.text == "") {
      showSnackBar("Dirección de correo requerida", scaffoldKey);
      return;
    }

    if (password.text == "") {
      showSnackBar("Debe suministrar una contraseña", scaffoldKey);
      return;
    }

    displayProgressDialog(context);
    // closeProgressDialog(context);
    // Navigator.of(context).push(new CupertinoPageRoute(
    //   builder: (BuildContext context) =>  new ServicesWidget()));

    // Navigator.of(context).pop(new MaterialPageRoute(builder: (context)=>MyHomePage()));
    //


    var emai=email.text;
    var pase=password.text;
    final response = await http.post("https://pd.domicompras.com/loginConect",body:{"email":"$emai","pass":"$pase"});
    log("response login:  ");
    log(response.body);
    var jsonRespon=json.decode(response.body);
    try {
      if (jsonRespon[0]['MemberId'] > 0) {
        var prefs = SharedPreferencesHelper();
        prefs.setUserID(jsonRespon[0]['MemberId'].toString());
        closeProgressDialog(context);
        var userIDss = jsonRespon[0]['MemberId'].toString();
        if (jsonRespon[0]['Gender'] == 'Conductor') {
          Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) => new UserList()));
        } else {
          Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) =>
              new OrdenesList()));
          log("userID  $userID");
        }
      } else {
        closeProgressDialog(context);
        showSnackBar(response.body, scaffoldKey);
      }
    }catch(ersf){
      log("Error login..");
      closeProgressDialog(context);
      showSnackBar(response.body, scaffoldKey);
    }
    /*logginUser(
        email: email.text.toLowerCase(), password: password.text.toLowerCase());
    if (response == successful) {
      closeProgressDialog(context);
      Navigator.of(context).pop(true);
    } else {
      closeProgressDialog(context);
      showSnackBar(response, scaffoldKey);
    }*/
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
