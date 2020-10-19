import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:conectcarga/model/carservices.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'my_trips.dart';
//import 'package:google_maps/screens/my_trips.dart';

class ServicesWidget extends StatefulWidget {
  ServicesWidget({Key key}) : super(key: key);

  _ServicesWidgetState createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget> {

  List<CarServices> carService = List();

  Future<List<CarServices>> fetchServices(http.Client client) async {
    final response = await http.get('https://pd.domicompras.com/servicios');

    return parseServices(response.body);
  }

  List<CarServices> parseServices(String responseBody) {
    return (json.decode(responseBody) as List)
          .map((data) => new CarServices.fromJson(data)).toList();
  }


  var time,sub;
  void handleTimeout(){
    setState(() {
      fetchServices(http.Client());
    });

    print("Se inicia el scan... ");
    //sub.cancel();
  }

  @override
  Widget build(BuildContext context) {

    //time = new Future.delayed(const Duration(milliseconds: 5000), handleTimeout);
    // time = new Timer.periodic(new Duration(seconds: 15), (timer) {
    //  debugPrint("Print after 5 seconds");
   //   handleTimeout();
  //  });
   // sub = time.asStream().listen((_) => print('goodnight moon'));

    return FutureBuilder<List<CarServices>>(
        future: fetchServices(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
 
          return snapshot.hasData
              ? (MyTrips(carServices: snapshot.data))
              : Center(child: CircularProgressIndicator());
        },
      );
  }
}