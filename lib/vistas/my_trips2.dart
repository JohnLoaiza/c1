import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/tools/CustomTextStyle.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:conectcarga/tools/rate_my_app.dart';
import 'package:conectcarga/vistas/perfilConductor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutUs.dart';
import 'delivery.dart';
import 'history.dart';
import 'login.dart';
import 'notifications.dart';
import 'ordenes_online.dart';

//void main() => runApp(MyApp());



class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserListState();
  }
}

class _UserListState extends State<UserList> {
  final String apiUrl = "https://pd.domicompras.com/servicios2";
  int selectedTab = 0;
  BuildContext contexte;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  bool isLoggedIn= true;
  var time,sub;
  List<dynamic> _users = [];

  void fetchUsers() async {
    var result = await http.get(apiUrl);
    setState(() {
      _users = json.decode(result.body);
      _buildList();
    });
  }

  String _nameSS(dynamic user) {
    return user['Address1'].toString()+
        " " +
        user['FirstName'].toString() +
        " " ;
  }


  String _TimeRequest(dynamic user) {
    return user['DateAdded'].toString().replaceAll("T", " ").replaceAll(".000Z", "");
  }

  String _Addres1(dynamic user) {
    return user['Address1'].toString();
  }
  String _Addres2(dynamic user) {
    return user['Address2'].toString();
  }
  String _valor(dynamic user) {
    return user['OrderTotal'].toString();
  }
  String _Metros(dynamic user) {
    return "Volumen: "+user['metros'].toString()+" mts3";
  }
  String _Peso(dynamic user) {
    return "Peso: " +user['Peso'].toString()+" kg";
  }

  String _age(Map<dynamic, dynamic> user) {
    return "Orden: " + user['OrderNumber'].toString();
  }

  Widget _buildList() {

    return _users.length != 0
        ? RefreshIndicator(
      child: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: _users.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(

              margin: EdgeInsets.only(top: 8, bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 25,
                    height: 25,
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
                    width: 10,
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


                          _showAlertDialog("Aceptar servicio",_users[index]['FirstName'].toString(),context,_users[index]['OrderNumber'].toString(),
                              _users[index]['OrderTotal'].toString(),_users[index]['Address1'].toString(),_users[index]['Address2'].toString(),_users[index]['Peso'].toString(),_users[index]['metros'].toString());

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
                                        _TimeRequest(_users[index]),
                                       // '${_users[index].carCustomer}',
                                        style: CustomTextStyle.mediumTextStyle.copyWith(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                    Container(
                                      child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "COP ",
                                                style: CustomTextStyle.regularTextStyle
                                                    .copyWith(
                                                    color: Colors.grey, fontSize: 12)
                                              ),
                                            TextSpan(
                                                text: _valor(_users[index]),
                                              //  text: "${_users[index].carRate}",
                                                style: CustomTextStyle.mediumTextStyle.copyWith(
                                                    color: Colors.black, fontSize: 14)
                                                )
                                          ])),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),

                                addressRow(Colors.tealAccent.shade700,
                                    _Addres1(_users[index]), "${_users[index]['time_request'].toString()}","Origen   "),
                                addressRow(Colors.redAccent.shade700,
                                  _Addres2(_users[index]), "${_users[index]['PaymentMethod'].toString()}","Destino ")/**/,
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5, left: 22),
                            child: Text(
                              _Peso(_users[index]),
                              // '${_users[index].carCustomer}',
                              style: CustomTextStyle.mediumTextStyle.copyWith(
                                  color: Colors.black54, fontSize: 11),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, left: 32),
                            child: Text(
                              _Metros(_users[index]),
                              // '${_users[index].carCustomer}',
                              style: CustomTextStyle.mediumTextStyle.copyWith(
                                  color: Colors.black54, fontSize: 11),
                            ),
                          )
                          ]
                      )
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
            /* Card(
              child: Row(

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
                  ListTile(
                    //leading: CircleAvatar(
                      //  radius: 30,
                      //  image: AssetImage("assets/images/iconoDesktop.png")),
                    title: Text(_name(_users[index])),
                    subtitle: Text(_location(_users[index])),
                    trailing: Text(_age(_users[index])),
                  )
                ],
              ),*/
           // );
          }),
      onRefresh: _getData,
    )
        : Center(child: CircularProgressIndicator());
  }
  addressRow(Color color, String address, String strTime,String prefi) {
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
                margin: EdgeInsets.only(bottom: 1),
                child: SizedBox(
                  width: 200.0,
                 // height: 30.0,
                  child: AutoSizeText(
                    "$prefi : $address",
                    maxLines: 2,

                  ),
                ),

              ),
             /* Container(
                child: Text(
                  strTime,
                  style: CustomTextStyle.regularTextStyle
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              )*/
            ],
          )
        ],
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  

  void _showAlertDialog(var titulo,var contenido,var contexto,var id,var valor,var origen,var destino,var peso,var volumen) async {
    await   showDialog(
        context: contexto,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0,left: 20),
            title: Text(""+titulo),
            content: Text(""+contenido+"\nOrden: "+id+"\nValor: "+valor+"\nOrigen: "+origen+"\nDestino: "+destino+"\nPeso: "+peso+"\nVolumen: "+volumen),
            actions: <Widget>[
              RaisedButton(
                color: Colors.blue,
                child: Text("CERRAR", style: TextStyle(color: Colors.white),),
                onPressed: (){ Navigator.of(context, rootNavigator: true).pop('dialog');

                 },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text("ACEPTAR", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  EnviarAcepta(id);
                },
              ),

              RaisedButton(
                color: Colors.blue,
                child: Text("Mostrar ", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  //openMapsSheet("https://waze.com/ul?q="+Uri.encodeComponent(origen));
                  openMapsSheetS(contexto);
                },
              )
            ],
          );
        }
    );
  }


  void _showAlertDialog2(var mensaje, var titulo,var contexto) async {
    await   showDialog(
        context: contexto,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0,left: 20),
            title: Text(""+titulo),
            content: Text(""+mensaje+""),
            actions: <Widget>[
              RaisedButton(
                child: Text("CERRAR", style: TextStyle(color: Colors.white),),
                onPressed: (){ Navigator.of(context, rootNavigator: true).pop('dialog'); },
              ),
              RaisedButton(
                child: Text("Mostrar Ruta", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  openMapsSheetS(contexto);
                },
              )
            ],
          );
        }
    );
  }
  Future<void> openMapsSheetC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  openMapsSheetS(context) async {
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


  static const timeout = const Duration(seconds: 5);
  static const ms = const Duration(milliseconds: 1);

  startTimeout([int milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return new Timer(duration, handleTimeout);
  }


  EnviarAcepta(var id) async {


    var myId = await getIDUsere();
    log("id enviado= $id   myID-- $myId");
    displayProgressDialog(context);



    //var tipoV=selectedValue.toString();
    final response = await http.post("https://pd.domicompras.com/aceptaService",
        body:{"id_conduc":"$myId","orden":"$id"});
    log("response registro acepta service:  ");
    log(response.body);
    try {
      var jsonRespon = json.decode(response.body);

      if (jsonRespon['response'] == "OK") {
        closeProgressDialog(context);
       // _buildList();
        _getData();
        _showAlertDialog2("La orden de carga ha sido tomada satisfactoriamente. ", "Orden OK", context);
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
  @override
  Widget build(BuildContext context) {
    time = startTimeout(5000);
    //time = new Future.delayed(const Duration(milliseconds: 5000), handleTimeout);
    //sub = time.asStream().listen((_) => print('Timer Update Ofertas'));
     //time=Timer.periodic(new Duration(seconds: 20), (timer) {
    //  debugPrint(timer.tick.toString());
    //});
    return Scaffold(
      appBar: AppBar(
        title: Text('Oferta de servicios'),
      ),
      body: Container(
        child: _buildList(),
      ),
      drawer: new Drawer(
        child:
        SingleChildScrollView(
    child:
        new Column(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(color: Colors.transparent), 
              child: new Image(
                image: new AssetImage("assets/images/avatar.png"),
                height: 90.0,
                width: 90.0,
              ),


              margin: EdgeInsets.only(top: 50.0),
            ),
            new SizedBox(
              height: 10.0,
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
                    new OrdenesOnline()));
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


  void handleTimeout(){

    _getData();
    print("Se inicia el getData ofertas... ");
    time.cancel();
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


  @override
  void dispose() {


    time.cancel();
    super.dispose();
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
  String id;
  WebviewFlutterPdf(this.id);
    WebViewController _controller;

    
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
      String _orden = "https://oportuna.red/conectcarga/servicios_pdf/";
      String pdf = ".pdf";


    @override 
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Orden $id'),
          actions: <Widget>[
            RaisedButton(
              color: Colors.yellowAccent,
              child: Text("Print"),
              onPressed: () {
                print(_orden+id+pdf);
              },
            )
          ],
          centerTitle: true,
        ),
       body: SafeArea(
         child: WebView(
           key: Key('webview'),
           initialUrl: "https://oportuna.red/conectcarga/servicios_pdf/",
           javascriptMode: JavascriptMode.unrestricted,
           onWebViewCreated: (WebViewController webViewController) {
             _controller = webViewController;
           },
         ),
       ),
      );
    }

  }

  class Url extends StatelessWidget {
  String id;

  Url(this.id);
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed:
            _launchURL(id),
        ),
      ),
    );
  }
  }

  _launchURL(var id) async {
    String fin = '.pdf';
  const url = 'https://conectcarga.com/servicios_pdf/';
  if (await canLaunch(url+id+fin)) {
    await launch(url+id+fin);
  } else {
    throw url+id+fin;
  }
}