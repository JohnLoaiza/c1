import 'package:conectcarga/MyPreferences.dart';
import 'package:conectcarga/vistas/my_trips2.dart';
import 'package:conectcarga/vistas/my_tripsCliente.dart';
import 'package:flutter/material.dart';


class PerfilCliente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<PerfilCliente> {
  MyPreferences _myPreferences = MyPreferences();


  @override
  Widget build(BuildContext context) {
    TextEditingController numberControler =
    TextEditingController(text: _myPreferences.number);

    TextEditingController emailControler =
    TextEditingController(text: _myPreferences.email);
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil",
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_circle, size: 140,)
                ],
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Correo:", style: TextStyle(fontSize: 25,)),
                  ),
                  Container(
                    width: 185,
                    child: TextField(
                      style: TextStyle(color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                      controller: emailControler,
                      onChanged: (value) {
                        _myPreferences.email = value;
                        _myPreferences.commit();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Numero:", style: TextStyle(fontSize: 25,)),
                  ),
                  Container(
                    width: 185,
                    child: TextField(
                      style: TextStyle(color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                      controller: numberControler,
                      onChanged: (value) {
                        _myPreferences.number = value;
                        _myPreferences.commit();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Contraseña:", style: TextStyle(fontSize: 25,)),
                  ),
                  Text(_myPreferences.password, style: TextStyle(fontSize: 25, color: Colors.blueAccent,),)

                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  height: 50,
                  width: 120,
                  child:   RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.blueAccent,
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdenesList()));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text("Guardar cambios", textAlign: TextAlign.center, style: TextStyle(fontSize: 23, color: Colors.white),),

                    ),
                  )
              )
            ],
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _myPreferences.init().then((value) {
      setState(() {
        _myPreferences = value;
      });
    });
  }
}
