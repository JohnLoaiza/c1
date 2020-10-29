import 'dart:async';
import 'package:conectcarga/MyPreferences.dart';
import 'dart:developer';
import 'package:conectcarga/position.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:conectcarga/model/carservices.dart';
import '../homechat.dart';
import '../homechatCliente.dart';
import 'my_trips2.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/tools/CustomTextStyle.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:conectcarga/vistas/perfilConductor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutUs.dart';
import 'delivery.dart';
import 'history.dart';
import 'login.dart';
import 'notifications.dart';

//void main() => runApp(MyApp());



class OrdenesOnline extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrdenesOnlineState();
  }
}

class _OrdenesOnlineState extends State<OrdenesOnline> {
  Position _position;
  StreamSubscription <Position> _positionStream;
  //


  final String apiUrl = "https://pd.domicompras.com/servicios4";
  int selectedTab = 0;
  
  BuildContext contexte;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  bool isLoggedIn= true;
  String barcode = "";
  List<dynamic> _users = [];

  void fetchUsers() async {
    var myId = await getIDUsere();
    var result = await http.get(apiUrl+"?id="+myId);
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
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent,
                              offset: Offset(4,0),
                              blurRadius: 10,
                            )
                          ]
                      ),
                      //height: 230,
                      child: GestureDetector(

                        onTap: () {
                          //  scan();
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>TripInfo(carServices:carServices[position])));
                          // log("tapdwndet ..$tapdowndet");
                          _showAlertDialog("Terminar servicio",_users[index]['FirstName'].toString(),context,_users[index]['OrderId'].toString(),
                              _users[index]['OrderTotal'].toString(),_users[index]['Address1'].toString(),_users[index]['Address2'].toString(),_users[index]['Peso'].toString(),_users[index]['metros'].toString());
                          _getCurrentLocation();
                          // print("onTap called.");
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orangeAccent, width: 1),
                              borderRadius: BorderRadius.circular(8)
                            ),
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
                                              color: Colors.black54, fontSize: 13),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5, left: 32),
                                        child: Text(
                                          _Metros(_users[index]),
                                          // '${_users[index].carCustomer}',
                                          style: CustomTextStyle.mediumTextStyle.copyWith(
                                              color: Colors.black54, fontSize: 13),
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
                  child: Text(
                    "$prefi : $address",
                    maxLines: 2, style: TextStyle(fontSize: 16.5),

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


  Future scan(String idOrden) async {
    log("Ini scanner   "+idOrden);
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

      var barcode = await BarcodeScanner.scan(options:options);
      setState(() {
        this.barcode = barcode.rawContent;
        if(idOrden==this.barcode) {
          EnviarAceptar(this.barcode);
        }else{

          _showAlertDialog2("Error", "Ocurrio un error en el proceso;\n Por favor intentelo nuevamente", context);
        }
        //SetUpSonido();
      });
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


  @override
  void initState() {
    super.initState();
    fetchUsers();
    _positionStream = getPositionStream(distanceFilter: 10, desiredAccuracy: LocationAccuracy.high, timeInterval: 30,).listen((Position position) {
      setState(() {
        print(position);
        _position = position;
      });
    });

  }

  @override
  void dispose () {
    super.dispose();
    _positionStream.cancel();
  }

  void _pdf(var contexto,var id,) async {

    await   showDialog(
        context: contexto,
        builder: (context) {
          return _launchURL(id);
        }
    );
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
                child: Text("Escanear", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  scan(id);
                  //EnviarAcepta(id);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RateServiceChofer()));
                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text("Mostrar Ruta", style: TextStyle(color: Colors.white),),
                onPressed: (){
                 // openMapsSheet(context);
                  openMapsSheet("https://waze.com/ul?q="+Uri.encodeComponent(origen));

                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text("Manifiesto de carga", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  _launchURL(id);
                },
              ),
              RaisedButton.icon(
                icon: Icon(Icons.chat, color: Colors.white,),
                label: Text("Chat", style: TextStyle(color: Colors.white),),color: Color(0xFF2daae1),
                onPressed: (){
                  // Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageChat(id)));

                },
              )
          //    RaisedButton(
          //      color: Colors.blue,
           //     child: Text("Compartir posicion", style: TextStyle(color: Colors.white),),
            //    onPressed: (){
             //     Navigator.of(context, rootNavigator: true).pop('dialog');

            //      _getCurrentLocation();
             //     Navigator.push(context, MaterialPageRoute(builder: (context) => PositionGps(id)));
            //    },
             // ),
            ],
          );
        }
    );
  }


  void _position1(var contexto,var id,var _locationMessage) async {

    await   showDialog(
        context: contexto,
        builder: (context) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Container(
                  color: Colors.white,
                  child: Text("Id: $id\n Posición: $_locationMessage"),
                ),
              ),
            ),

          );
        }
    );
  }


  String _locationMessage = "";

  void _getCurrentLocation() async {
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });
  }

  void _showAlertDialog2(var titulo,var contenido,var contexto) async {
    await   showDialog(
        context: contexto,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0,left: 20),
            title: Text(""+titulo),
            content: Text(""+contenido+""),
            actions: <Widget>[
              RaisedButton(
                child: Text("CERRAR", style: TextStyle(color: Colors.white),),
                onPressed: (){ Navigator.of(context, rootNavigator: true).pop('dialog'); },
              ),


            ],
          );
        }
    );
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

  Future<void> openMapsSheet(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<String> getIDUsere() async{
    var prefs =SharedPreferencesHelper();
    var id=  prefs.myUserID();
    return id;
  }


  EnviarAceptar(var id) async {


    var myId = await getIDUsere();
    log("id enviado= $id   myID-- $myId");
    displayProgressDialog(context);



    //var tipoV=selectedValue.toString();
    final response = await http.post("https://pd.domicompras.com/aceptaService2",
        body:{"id_conduc":"$myId","orden":"$id"});
    log("response registro acepta service:  ");
    log(response.body);
    try {
      var jsonRespon = json.decode(response.body);

      if (jsonRespon['response'] == "OK") {
        closeProgressDialog(context);
        _showAlertDialog2("Proceso Exitoso", "La orden ha sido confirmada exitosamente", context);
        // _buildList();
       // showSnackBar(response.body, "Servicio concretado con exito");
        _getData();
      } else {
        closeProgressDialog(context);
        _showAlertDialog2("Error", "Ocurrio un error en el proceso;\n Por favor intentelo nuevamente", context);
       // showSnackBar(response.body, "No ha sido posible Terminar el servicio. Por favor intenta nuevamente.");
      }
    }catch(erd){
      closeProgressDialog(context);
      // Navigator.of(context).push(new CupertinoPageRoute(
      //    builder: (BuildContext context) => new MyTripsC(carServices: [])));
      log(erd);}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(
            color: Colors.white,
            child: Text("Recomendacion", style: TextStyle(color: Colors.blue,fontSize: 10),),
            onPressed: () {
              _Recomend(context);
            },
          ),
        ],
        title: Text('Ordenes En Curso'),
      ),
      body: Container(
        child: _buildList(),
      ),

    );
  }

  void _Recomend(var contexto) async {
    await   showDialog(
        context: contexto,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0,left: 20),
            content: Text("Se recomienda abrir los" "\nmanifiestos de carga mediante" "\n Google Chorme", textAlign: TextAlign.center,),
            actions: <Widget>[
              RaisedButton(
                child: Text("CERRAR", style: TextStyle(color: Colors.white),),
                onPressed: (){ Navigator.of(context, rootNavigator: true).pop('dialog'); },
              ),
            ],
          );
        }
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

}
class RateServiceChofer extends StatefulWidget{
  Image image;

  @override
  _RateServiceState createState() => _RateServiceState();
}


class _RateServiceState extends State<RateServiceChofer> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  var rating1=3.0,rating2=3.0,rating3=3.0,rating4=3.0,rating5=3.0,rating6=3.0,rating7=3.0,rating8 = 3.0;
  var rat;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('EXPERIENCIA DEL SERVICIO', style: TextStyle(color: Colors.black, fontSize: 10,),),
          centerTitle: true,

        ),
        backgroundColor: Color(0xffffffff),
        body:





        // Center(

        Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 18),
            child: Column(

                children: <Widget>[
                  Container(

                    // color: Colors.white,
                      height: 170,
                      //width: 200,
                      child: Image.asset('assets/images/calificacion.jpeg')
                  ),
                  RowStartsCalificaServicio1('Mercancia'),
                  RowStartsCalificaServicio2('Cumplimiento horas de cargue'),
                  RowStartsCalificaServicio3('Cumplimiento horas de descargue'),
                  RowStartsCalificaServicio4('Amabilidad y trato al conductor'),
                  RowStartsCalificaServicio5('Pagos a tiempo'),

                  appButton(
                      btnTxt: "Enviar",
                      onBtnclicked: verifyDetails,
                      btnPadding: 20.0,
                      btnColor: Color(0xFFFFFFFF))

                ]
            )
        )
      // )
    );







  }


  verifyDetails() async {



    displayProgressDialog(context);



    //var tipoV=selectedValue.toString();
    final response = await http.post("https://pd.domicompras.com/registroUser2",
        body:{"tipoVehiculo":"Cliente"});
    log("response registro clientes:  ");
    log(response.body);
    try {
      var jsonRespon = json.decode(response.body);

      if (jsonRespon['ID'] > 0) {
        closeProgressDialog(context);
        Navigator.of(context).push(new CupertinoPageRoute(
            builder: (BuildContext context) => new UserList()));
      } else {
        closeProgressDialog(context);
        showSnackBar(response.body, scaffoldKey);
      }
    }catch(erd){
      closeProgressDialog(context);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new UserList()));
      log(erd);}

  }

  RowStartsCalificaServicio1(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating1 = v;});
                  },
                  starCount: 5,
                  rating: rating1,
                  size: 30.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }

  RowStartsCalificaServicio2(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating2 = v;});
                  },
                  starCount: 5,
                  rating: rating2,
                  size: 30.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }

  RowStartsCalificaServicio3(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating3 = v;});
                  },
                  starCount: 5,
                  rating: rating3,
                  size: 30.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }

  RowStartsCalificaServicio4(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating4 = v;});
                  },
                  starCount: 5,
                  rating: rating4,
                  size: 30.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }


  RowStartsCalificaServicio5(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating5 = v;});
                  },
                  starCount: 5,
                  rating: rating5,
                  size: 30.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }


  RowStartsCalificaServicio6(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating6 = v;});
                  },
                  starCount: 5,
                  rating: rating6,
                  size: 30.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }


  RowStartsCalificaServicio7(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating7 = v;});
                  },
                  starCount: 5,
                  rating: rating7,
                  size: 40.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }


  RowStartsCalificaServicio8(var texto){


    return  Container(
        child: Row(

            children: <Widget>[
              Container(
                  color: Colors.white,
                  width: 140,
                  //height: 45,
                  child: Text(texto, textAlign: TextAlign.left, style: TextStyle(color: Colors.black,fontSize: 16,))
              ),
              SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {

                    setState(() {rating8 = v;});
                  },
                  starCount: 5,
                  rating: rating8,
                  size: 40.0,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.blur_on,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing:0.0
              ),
            ]
        )
    );

  }




}


class PositionGps extends StatefulWidget {
  String id;
  PositionGps(this.id);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<PositionGps> {
  MyPreferences _myPreferences = MyPreferences();
  int fecha;
  String _locationlat = "";
  String _locationlgn = "";
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  void _getCurrentLocation() async {
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationlat = "Location ${_position?.latitude ?? '-'}, ${_position?.longitude ??
          '-'}";
    });
  }
  Position _position;
  StreamSubscription <Position> _positionStream;


  @override
  void initState (){
    super.initState();
    _positionStream = getPositionStream(distanceFilter: 10, desiredAccuracy: LocationAccuracy.high, timeInterval: 30,).listen((Position position) {
      setState(() {
        print(position);
        _position = position;
        setState(() {
          _locationlat = "${_position?.latitude ?? '-'}";
          _locationlgn = "${_position?.longitude ?? '-'}";
          _myPreferences.location1 = "${_position?.latitude ?? '-'}";
          _myPreferences.location2 = "${_position?.longitude ?? '-'}";
          _myPreferences.fecha = "${currentTimeInSeconds()}";
          _myPreferences.id = "${widget.id}";
        });
      });
    });
  }

  @override
  void dispose () {
    super.dispose();
    _positionStream.cancel();
  }

  static int currentTimeInSeconds () {
    var ms = (new DateTime.now ()). millisecondsSinceEpoch;
    return (ms / 1000) .round ();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: scaffoldKey,
      color: Colors.white,
      home: Container(
        color: Colors.white,
        child:
        Center(
          child: RaisedButton(
            child: Text(
              "${_position?.latitude ?? '-'}, ${_position?.longitude ??
                  '-'}, ${widget.id}, ${currentTimeInSeconds()}", style: TextStyle(fontSize: 20, color: Colors.black),),
            onPressed: verifyDetails,
          ),
        ),
      ),
      // )
    );
  }
  verifyDetails() async {
    int currentTimeInSeconds () {
      var ms = (new DateTime.now ()). millisecondsSinceEpoch;
      return (ms / 1000) .round ();
    }

    var preferences = SharedPreferencesHelper();

    var orden = widget.id;
    displayProgressDialog(context);
    var location=_locationlat.toString();
    var location2=_locationlgn.toString();



    final response = await http.post("https://pd.domicompras.com/latlng",
        body:{"fecha":"${currentTimeInSeconds()}","lat":"$location","lng":"$location2","orden":"$orden"});
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