import 'package:conectcarga/MyPreferences.dart';
import 'package:conectcarga/vistas/my_trips2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


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

    TextEditingController nameControler =
    TextEditingController(text: _myPreferences.name);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          shadowColor: Colors.orange,
          title: Text("Perfil",
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
            children: <Widget>[
              Container(
                  color: Colors.green,
                  height: 220,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/images/AvatarC.png", height: 140,),
                          SizedBox(
                            height: 20,
                          ),
                          Text(_myPreferences.name ?? "Name", style: TextStyle(color: Colors.white, fontSize: 25),),
                        ],
                      )
                  )
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
                      style: TextStyle(color: Colors.green),
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
                      style: TextStyle(color: Colors.green),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text("Contraseña:", style: TextStyle(fontSize: 25,)),
                  ),
                  Text(_myPreferences.password, textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.green,),)

                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  width: 120,
                  child:   RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.green,
                    onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserList()));
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
