import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/tools/CustomTextStyle.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:conectcarga/vistas/perfilCliente.dart';
import 'package:conectcarga/vistas/perfilConductor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:map_launcher/map_launcher.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'aboutUs.dart';
import 'delivery.dart';
import 'generate.dart';
import 'history.dart';
import 'historyC.dart';
import 'login.dart';
import 'notifications.dart';
import 'ordenes_online.dart';
import 'package:conectcarga/homechat.dart';

//void main() => runApp(MyApp());



class OrdenesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrdenesListState();
  }
}

class _OrdenesListState extends State<OrdenesList> {
  final String apiUrl = "https://pd.domicompras.com/serviciosC2?userid=";
  int selectedTab = 0;
  BuildContext contexte;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  bool isLoggedIn= true;
  var time,sub;
  List<dynamic> _users = [];

  void fetchUsers() async {
    var myId = await getIDUsere();
    var result = await http.get(apiUrl+""+myId);

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
                          _showAlertDialog("Comfirmar Servicio",_users[index]['FirstName'].toString(),context,_users[index]['OrderNumber'].toString(),
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
                child: Text("Cerrar", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RateService()));
                },
              ),
              RaisedButton(
                child: Text("Generar QR", style: TextStyle(color: Colors.white),),color: Color(0xFF2daae1),
                onPressed: (){
                  // Navigator.of(context, rootNavigator: true).pop('dialog');

                  Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateScreen(objstr:id)));
                },
              )
            ],
          );
        }
    );
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


  @override
  Widget build(BuildContext context) {
    time = startTimeout(15000);
    //time = new Future.delayed(const Duration(milliseconds: 5000), handleTimeout);
    //sub = time.asStream().listen((_) => print('Timer Update Ofertas'));
    //time=Timer.periodic(new Duration(seconds: 20), (timer) {
    //  debugPrint(timer.tick.toString());
    //});
    return Scaffold(

      appBar: AppBar(
        title: Text('Ordenes de Carga'),
        backgroundColor: Colors.green,
      ),
      body: Container(

        child: _buildList(),
      ),
      drawer: new Drawer(
        child: new Column(

          children: <Widget>[

            new Container(
              decoration: new BoxDecoration(color: Colors.transparent),
              child: new Image(
                image: new AssetImage("assets/images/avatar.png"),
                height: 80.0,
                width: 80.0,
              ),



            ),


            new Text(acctName, style: TextStyle(color: Colors.red),),


            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Notificaciones"),
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
                    builder: (BuildContext context) => new GirliesHistoryC()));
              },
            ),
            new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.chat_bubble,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Chat"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new HomePageChat()));
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
                    builder: (BuildContext context) => new PerfilCliente()));
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
              title: new Text("Mis Direcciones"),
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
              title: new Text(isLoggedIn == true ? "Logout" : "Login"),
              onTap: checkIfLoggedIn,
            ),
          ],
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


   // time.cancel();
    super.dispose();
  }




}
class RateService extends StatefulWidget{
  Image image;

  @override
  _RateServiceState createState() => _RateServiceState();
}

class _RateServiceState extends State<RateService> {
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
          title: Text('EXPERIENCIA DEL SERVICIO', style: TextStyle(color: Colors.black),),
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
                  RowStartsCalificaServicio1('Entregas a tiempo'),
                  RowStartsCalificaServicio2('Productos en buen estado'),
                  RowStartsCalificaServicio3('Entregas completas'),
                  RowStartsCalificaServicio4('Documentación'),
                  RowStartsCalificaServicio5('Lugar correcto'),
                  RowStartsCalificaServicio6('Presentación personal'),
                  RowStartsCalificaServicio7('Amabilidad y lenguaje'),
                  RowStartsCalificaServicio8('Liempieza del vehiculo'),
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
            builder: (BuildContext context) => new OrdenesList()));
      } else {
        closeProgressDialog(context);
        showSnackBar(response.body, scaffoldKey);
      }
    }catch(erd){
      closeProgressDialog(context);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new OrdenesList()));
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
