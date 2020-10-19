import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:conectcarga/vistas/profile.dart';
import 'package:conectcarga/vistas/serviceswidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conectcarga/model/carservices.dart';
import 'package:conectcarga/vistas/trip_info.dart';
import 'package:conectcarga/tools/CustomTextStyle.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'aboutUs.dart';
import 'delivery.dart';
import 'favorites.dart';
import 'history.dart';
import 'login.dart';
import 'messages.dart';
import 'notifications.dart';
import 'perfilConductor.dart';
import 'package:http/http.dart' as http;
//import 'Listviewdetailsscreen.dart';

class MyTrips extends StatefulWidget {

  String fullnamer;
  MyTrips({Key key,this.carServices}) : super(key: key);
  List<CarServices> carServices;
  _MyTripsState createState() =>
      _MyTripsState(carServices: this.carServices);

  //@override
 // _MyTripsState createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<CarServices> carServices;
  _MyTripsState({this.carServices});
  int selectedTab = 0;
  BuildContext contexte;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  bool isLoggedIn= true;


  @override
  Widget build(BuildContext context) {
    contexte=context;
    return Scaffold(


      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,

      appBar: new AppBar(
        title:
          //onLongPress: openAdmin,
          Text("Servicios Disponibles")
        ,
        centerTitle: true,
        actions: <Widget>[

          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) =>
                        new GirliesMessages()));
                  }),
              new CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.red,
                child: new Text(
                  "0",
                  style: new TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
            ],
          )
        ],
      ),
    /*  appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Servicios",
          style: CustomTextStyle.mediumTextStyle.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.access_alarm),
          ),
        ],
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
             // Navigator.pop(context);
            }),
      ),*/
      body: Container(
        child: ListView(
          children: <Widget>[

            ListView.builder(
                itemBuilder: (context, position) {
                  //if (position == 0 || position % 3 == 0) {
                  //  return createDateHeader();
                 // } else {
                    return createTripListItem(position);
                  //}
                },
                shrinkWrap: true,
                primary: false,
                itemCount: carServices.length)

          ],
        ),
      ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(color: Colors.transparent),
                child: new Image(
                  image: new AssetImage("assets/images/avatar.png"),
                  height: 110.0,
                  width: 110.0,
                ),


                margin: EdgeInsets.only(top: 10.0),
              ),
              new SizedBox(
                height: 30.0,
              ),

              new Text(acctName),

              new SizedBox(
                height: 50.0,
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Ordenes en curso"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                      new GirliesNotifications()));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Historial"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesHistory()));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Ver Pdf"),
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => WebviewFlutterPdf()));
                },
              ),
              new Divider(),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Perfil"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new SettingsPage()));
                },
              ),
              new ListTile(
                leading: new CircleAvatar(
                  child: new Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Mi Cuenta"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesDelivery()));
                },
              ),
              new Divider(),
              new ListTile(
                trailing: new CircleAvatar(
                  child: new Icon(
                    Icons.help,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text("Acerca de"),
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesAboutUs()));
                },
                //
              ),
              new ListTile(
                trailing: new CircleAvatar(
                  child: new Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: new Text(isLoggedIn == true ? "Salir" : "Login"),
                onTap: checkIfLoggedIn,
              ),
            ],
          ),
        ),
    );
  }

  createDateHeader() {
    return Container(
      margin: EdgeInsets.only(left: 16,top: 16),
      child: Text(
        "MON 8 OCT 2018",
        style: CustomTextStyle.mediumTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }

  createTripListItem(int position) {
    double bottomMargin = 0.0;
    if (position == 5) {
      bottomMargin = 16.0;
    }
    return Container(

      margin: EdgeInsets.only(top: 8, bottom: bottomMargin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(top: 8, left: 1),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: AssetImage("assets/images/iconoDesktop.png")),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 10)
                ]),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: Offset(4,0),
                      blurRadius: 10,
                    )
                  ]
              ),
              //height: 230,
             child: GestureDetector(

               onTap: () {
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>TripInfo(carServices:carServices[position])));
                // log("tapdwndet ..$tapdowndet");
                 _showAlertDialog("Aceptar servicio",carServices[position].carService,contexte,carServices[position].OrderNumber);
                 // print("onTap called.");
                },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.all(4),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${carServices[position].carCustomer}',
                              style: CustomTextStyle.mediumTextStyle,
                            ),
                          ),
                          Container(
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "COP ",
                                  style: CustomTextStyle.regularTextStyle
                                      .copyWith(
                                          color: Colors.grey, fontSize: 12)),
                              TextSpan(
                                  text: "${carServices[position].carRate}",
                                  style: CustomTextStyle.mediumTextStyle.copyWith(
                                      color: Colors.black, fontSize: 14))
                            ])),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      addressRow(Colors.tealAccent.shade700,
                          "${carServices[position].carService}", "${carServices[position].time_request}"),
                      addressRow(Colors.redAccent.shade700,
                          "${carServices[position].carRate}", "${carServices[position].PaymentMethod}")
                    ],
                  ),

                ),

              ),
              ),
            ),
            flex: 100,
          )
        ],

      ),
    );
  }

  addressRow(Color color, String address, String strTime) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(top: 3),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[

              Container(
                margin: EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  width: 200.0,
                  height: 30.0,
                child: AutoSizeText(
                  address,
                  maxLines: 2,

                ),
                ),

              ),
              Container(
                child: Text(
                  strTime,
                  style: CustomTextStyle.regularTextStyle
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

 void checkIfLoggedIn() async {
   // if (isLoggedIn == false) {
      bool response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new GirliesLogin()));
      if (response == true) getCurrentUser();
      return;
   // }
    //bool response = await appMethods.logOutUser();
    //if (response == true) getCurrentUser();
  }

  Future getCurrentUser() async {
   /* acctName = await getStringDataLocally(key: acctFullName);
    acctEmail = await getStringDataLocally(key: userEmail);
    acctPhotoURL = await getStringDataLocally(key: photoURL);
    isLoggedIn = await getBoolDataLocally(key: loggedIN);*/
    acctName = "";
    acctEmail = "";
    acctPhotoURL = "";
    isLoggedIn = false;
    //print(await getStringDataLocally(key: userEmail));
    acctName == null ? acctName = "Guest User" : acctName;
    acctEmail == null ? acctEmail = "guestUser@email.com" : acctEmail;
    setState(() {});
  }
  void _showAlertDialog(var titulo,var contenido,var contexto,var id) async {
    await   showDialog(
        context: contexto,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0,left: 20),
            title: Text(""+titulo),
            content: Text(""+contenido+"  "+id),
            actions: <Widget>[
              RaisedButton(
                child: Text("CERRAR", style: TextStyle(color: Colors.white),),
                onPressed: (){ Navigator.of(context, rootNavigator: true).pop('dialog');
                 Navigator.push(context, MaterialPageRoute(builder: (context) => RateServiceChofer()));
                  },
              ),
              RaisedButton(
                child: Text("ACEPTAR", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  EnviarAcepta(id);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => RateServiceChofer()));

                  },
              ),
              RaisedButton(
                child: Text("Mostrar Ruta", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  openMapsSheet(context);
                },
              )
            ],
          );
        }
    );
  }


  openMapsSheet(context) async {
    try {
      final title = "Central Medellin";
      final description = "";
      final coords = Coords(6.215950, -75.574773);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

   Future<String> getIDUsere() async{
   var prefs =SharedPreferencesHelper();
   var id=  prefs.myUserID();
    return id;
  }

  EnviarAcepta(var id) async {


var myId = await getIDUsere();
log("id enviado= $id   myID-- $myId");
    displayProgressDialog(context);



    //var tipoV=selectedValue.toString();
    final response = await http.post("https://pd.domicompras.com/aceptaService",
        body:{"id_conduc":"$myId","orden":"$id"});
    log("response registro clientes:  ");
    log(response.body);
    try {
      var jsonRespon = json.decode(response.body);

      if (jsonRespon['response'] == "OK") {
        closeProgressDialog(context);
        Navigator.of(context).push(new CupertinoPageRoute(
            builder: (BuildContext context) => new ServicesWidget()));
      } else {
        closeProgressDialog(context);
        showSnackBar(response.body, "No ha sido posible aceptar el servicio. Por favor intenta nuevamente.");
      }
    }catch(erd){
      closeProgressDialog(context);
     // Navigator.of(context).push(new CupertinoPageRoute(
      //    builder: (BuildContext context) => new MyTripsC(carServices: [])));
      log(erd);}

  }
}

class RateServiceChofer extends StatelessWidget{
  Image image;
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text('EXPERIENCIA DEL SERVICIO', style: TextStyle(color: Colors.black),),
      centerTitle: true,
      
    ),
    backgroundColor: Color(0xffffffff),
    body: 
   
    
    


     Center(

    child:  Container(
        color: Colors.white,
          margin: EdgeInsets.only(left: 18),
        child: Column(

          children: <Widget>[
            Container(

           // color: Colors.white,
            height: 300,
            width: 300,
            child: Image.asset('assets/images/calificacion.jpeg', cacheHeight: 600,)
            ),
            Container(
            width: 700,
            height: 130,
              color: Colors.white,
              child: Text('MERCANCIA DEBIDAMENTE EMBALADA', textAlign: TextAlign.left, style: TextStyle(fontSize:20))
            ),
            Container(
               width: 700,
            height: 130,
              color: Colors.white,
              child: Text('CUMPLIMIENTO HORAS DE CARGUE', textAlign: TextAlign.left, style: TextStyle(fontSize:20))
            ),
            Container(
               width: 700,
            height: 130,
              color: Colors.white,
              child: Text('CUMPLIMIENTO HORAS DE DESCARGUE', textAlign: TextAlign.left, style: TextStyle(fontSize:20))
            ),
            Container(
               width: 700,
            height: 130,
              color: Colors.white,
              child: Text('AMABILIDAD Y TRATO AL CONDUCTOR', textAlign: TextAlign.left, style: TextStyle(fontSize:20))
            ),
            Container(
               width: 700,
            height: 120,
              color: Colors.white,
              child: Text('PAGOS A TIEMPO', textAlign: TextAlign.left, style: TextStyle(fontSize:20))
            ),
           
           

       ]
      )
      )
      // )
       ));

}
}

class WebviewFlutterPdf extends StatelessWidget {
    WebViewController _controller;
    WebviewFlutterPdf({Key key}) : super(key: key);
    
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
           initialUrl: "https://docs.google.com/forms/d/1ha__VLoCobzMOsqgrx2csFZm0_HGLJWVX1ZmvrhFXRg/edit",
           javascriptMode: JavascriptMode.unrestricted,
           onWebViewCreated: (WebViewController webViewController) {
             _controller = webViewController;
           },
         ),
       ),
      );
    }

  }/**/
