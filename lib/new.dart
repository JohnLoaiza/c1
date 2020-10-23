import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class New extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<New> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Noticias"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),

              margin: EdgeInsets.all(10),
              child: Center(
                child: Container(
                  width: 400,
                  height: 280,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Image.asset("assets/images/gps.jpg", fit: BoxFit.contain, ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5, left: 5),
                        height: 35,
                        width: 380,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.deepOrange, width: 2)
                        ),

                        child: Center(child:
                        Text("Seguimiento a conductor",style: TextStyle(color: Colors.black, fontSize: 20),),
                      ),
                      ),
                      Container(
                        height: 65,
                        width: 370,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Text("Lo nuevo de conectcarga traera la posicion de tu conductor en todo momento...\n \n Ver mas>> ",
                              textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                              onTap: (){

                              },
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),

              margin: EdgeInsets.all(10),
              child: Center(
                child: Container(
                  width: 400,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Image.asset("assets/images/ruta.jpeg", fit: BoxFit.contain, ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5, left: 5),
                        height: 35,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.deepOrange, width: 2)
                        ),

                        child: Center(child:
                        Text("Accidente ruta Medellin-Bogota",style: TextStyle(color: Colors.black, fontSize: 20),),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 370,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                                onTap: (){

                                },
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child:  Text("Conozca la mejor ruta para llegar putual a su destino...\n \n Ver mas>> ",
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

}
