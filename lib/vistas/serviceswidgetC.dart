import 'dart:developer';


import 'package:conectcarga/data/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:conectcarga/model/carservices.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'my_tripsC.dart';
//import 'package:google_maps/screens/my_trips.dart';

class ServicesWidgetC extends StatefulWidget {

  ServicesWidgetC({Key key,  this.objstr}) : super(key: key);
var objstr;
  _ServicesWidgetState createState() => _ServicesWidgetState(objstr:objstr);

}

void getDataUserID() async{


}

class _ServicesWidgetState extends State<ServicesWidgetC> {
  var objstr;

_ServicesWidgetState({this.objstr});
  List<CarServices> carService = List();
   var myUserID ;
  var prefs = SharedPreferencesHelper();

  // String muUS=myUserID.toString();
  //getDataUserID();
  Future<List<CarServices>> fetchServices(http.Client client) async {
var uri="https://pd.domicompras.com/serviciosC?userid=$objstr";
log("URL SERVICIOS MY  $uri");
log(this.objstr.toString());
    final response = await http.get(uri);

    return parseServices(response.body);
  }

  List<CarServices> parseServices(String responseBody) {
    return (json.decode(responseBody) as List)
          .map((data) => new CarServices.fromJson(data)).toList();
  }
  
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<CarServices>>(
        future: fetchServices(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
 
          return snapshot.hasData
              ? (MyTripsC(carServices: snapshot.data))
              : Center(child: CircularProgressIndicator());
        },
      );
  }


  static   getIDUsere() async{
    var prefs = SharedPreferencesHelper();
   int myUserID = 0;
    return myUserID;
  }
}