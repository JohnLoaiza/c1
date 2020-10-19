

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:conectcarga/tools/CustomTextStyle.dart';
import 'package:conectcarga/tools/app_data.dart';
import 'package:conectcarga/tools/app_tools.dart';
import 'package:conectcarga/vistas/perfilConductor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:map_launcher/map_launcher.dart';

import 'aboutUs.dart';
import 'delivery.dart';
import 'history.dart';
import 'login.dart';
import 'notifications.dart';

//void main() => runApp(MyApp());



class GirliesHistoryC extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GirliesHistoryCState();
  }
}

class _GirliesHistoryCState extends State<GirliesHistoryC> {
  final String apiUrl = "https://pd.domicompras.com/serviciosHistoCli";
  int selectedTab = 0;
  BuildContext contexte;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  bool isLoggedIn= true;

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
                         /* _showAlertDialog("Aceptar servicio",_users[index]['FirstName'].toString(),context,_users[index]['OrderNumber'].toString(),
                              _users[index]['OrderTotal'].toString(),_users[index]['Address1'].toString(),_users[index]['Address2'].toString(),_users[index]['Peso'].toString(),_users[index]['metros'].toString());
                          */// print("onTap called.");
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
    log("response registro acepta service:  ");
    log(response.body);
    try {
      var jsonRespon = json.decode(response.body);

      if (jsonRespon['response'] == "OK") {
        closeProgressDialog(context);
        // _buildList();
        _getData();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Ordenes OK'),
      ),
      body: Container(
        child: _buildList(),
      ),

    );
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
