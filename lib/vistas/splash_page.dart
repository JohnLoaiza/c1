import 'package:auto_size_text/auto_size_text.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:conectcarga/data/values.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';

import 'signup.dart';
import 'signupC.dart';

class SplashPage extends StatefulWidget {
  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<SplashPage> {
  BuildContext _context;

  bool switchControl = true;
  bool switchControl2 = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    // delay by one second before handling navigation
    Future.delayed(
      Duration(seconds: 1), () async {

        // if phone is connect then check if user is logged in or not
        // if logged go to home page, login page otherwise


        //}
      },
    );
  }


  void toggleSwitch(bool value) {

    if(switchControl == false)
    {
      setState(() {
        switchControl = true;
        switchControl2  = false;
        //textHolder = 'Switch is ON';
      });
     // print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.

    }
    else
    {
      setState(() {
        switchControl = false;
        switchControl2  = true;
       // textHolder = 'Switch is OFF';
      });
     // print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }
  void toggleSwitch2(bool value) {

    if(switchControl2 == false)
    {
      setState(() {
        switchControl2 = true;
        switchControl  = false;
        //textHolder = 'Switch is ON';
      });
      // print('Switch is ON');
      // Put your code here which you want to execute on Switch ON event.

    }
    else
    {
      setState(() {
        switchControl2 = false;
        switchControl  = true;
        // textHolder = 'Switch is OFF';
      });
      // print('Switch is OFF');
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Container(
          decoration: BoxDecoration(color:Colors.white),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image(
                  image: new AssetImage("assets/images/conectcarga.png"),

                  width: 150.0,
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new Image(
                  image: new AssetImage("assets/images/logoSplash.png"),
                  height: 170.0,
                  width: 170.0,
                ),
                Text(
                  "Se parte de nuestro equipo de trabajo.",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.normal),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 22),
                  padding:
                  EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8,left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Switch(value: switchControl, onChanged: toggleSwitch, activeColor: Color(0xFF2daae1),),
                            AutoSizeText('Quiero transportar carga.', maxLines:2),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8,left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Switch(value: switchControl2, onChanged: toggleSwitch2, activeColor: Color(0xFF2daae1),),
                            AutoSizeText('Quiero que transporten mi carga.', maxLines:2),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8,left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            appButton(
                                btnTxt: "Registro",
                                onBtnclicked: verifySplash,
                                btnPadding: 20.0,
                                btnColor: Color(0xFFFFFFFF)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifySplash() async {

    if(switchControl){
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => new SignUp()));

    }
    if(switchControl2){
      Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => new SignUpC()));
    }
  }
}
