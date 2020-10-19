import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:conectcarga/tools/rate_my_app.dart';
import 'package:conectcarga/vistas/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conectcarga/model/carservices.dart';
import 'package:conectcarga/vistas/trip_info.dart';
import 'package:conectcarga/tools/CustomTextStyle.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'aboutUs.dart';
import 'delivery.dart';
import 'favorites.dart';
import 'generate.dart';
import 'history.dart';
import 'historyC.dart';
import 'login.dart';
import 'messages.dart';
import 'notifications.dart';
import 'perfilCliente.dart';
import 'package:http/http.dart' as http;

//import 'Listviewdetailsscreen.dart';

class MyTripsC extends StatefulWidget {
  MyTripsC({Key key, this.carServices}) : super(key: key);
  List<CarServices> carServices;
  _MyTripsState createState() =>
      _MyTripsState(carServices: this.carServices);

  //@override
 // _MyTripsState createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTripsC> with WidgetsBindingObserver{


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('state = $state');
  }


  List<CarServices> carServices;
  _MyTripsState({this.carServices});
  int selectedTab = 0;
  BuildContext contexte;
  String acctName = "Pepe";
  String acctEmail = "pepe@pepe.com";
  String acctPhotoURL = "";
  bool isLoggedIn= true;
  int myUserID =0;

  @override
  Widget build(BuildContext context) {
    contexte=context;
    return Scaffold(


      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,

      appBar: new AppBar(
        title:
          //onLongPress: openAdmin,
          Text("Solicitudes de carga")
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

      body: Container(
        child: ListView(
          children: <Widget>[


           /* Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),*/
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
                 _showAlertDialog("Calificar Servicio",carServices[position].carService,contexte);
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
    //if (isLoggedIn == false) {
      bool response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new GirliesLogin()));
      if (response == true) getCurrentUser();
      return;
    //}
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
  void _showAlertDialog(var titulo,var contenido,var contexto) async {
    await   showDialog(
        context: contexto,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0,left: 20),
            title: Text(""+titulo),
            content: Text(""+contenido),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RateService()));
                  },
              )
            ],
          );
        }
    );
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
            builder: (BuildContext context) => new MyTripsC(carServices: [])));
      } else {
        closeProgressDialog(context);
        showSnackBar(response.body, scaffoldKey);
      }
    }catch(erd){
      closeProgressDialog(context);
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new MyTripsC(carServices: [])));
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
