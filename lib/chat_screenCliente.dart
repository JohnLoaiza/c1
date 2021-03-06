import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'chat_messageCliente.dart';
import 'shared_preferences_helper.dart';
import 'values.dart';
import 'data.dart';
import 'chat_message.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class ChatScreenC extends StatefulWidget {
  ChatScreenC(this.id);
  String id;

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreenC> {
  final TextEditingController _textController = new TextEditingController();
  List<ChatMessageC> _messages = <ChatMessageC>[];
  SharedPreferencesHelper helpe = new SharedPreferencesHelper();
  final String apiUrl = "https://pd.domicompras.com/servicios2";
  var time;
  var conta=0;
  var lastID=0;
  var myUsID="";
  var myImagePath;
  var MyTurno="0";
  String _selectedCity;
  List<dynamic> _users = [];

  void fetchUsers() async {
    var result = await http.get(apiUrl);
    setState(() {
      _users = json.decode(result.body);
      GetChatList();

    });
  }


  void _handleSubmitted(String text) {
    if(text.trim()==""){

    }else {
      PostChatMsg(text);
    }
    _textController.clear();


  }

  @override
  void initState() {
    GetChatList();
    time = startTimeout(100);
    super.initState();
  }


  Widget _textComposerWidget() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child:
              TypeAheadFormField(
                direction:AxisDirection.up,
                errorBuilder: (BuildContext context, Object error) =>
                    Text(
                        'No encontrado..',
                        style: TextStyle(
                            color: Theme.of(context).errorColor
                        )
                    ),
                hideOnEmpty :true,
                textFieldConfiguration: TextFieldConfiguration(
                  //decoration: InputDecoration(labelText: 'City'),
                  controller: this._textController,
                ),
                suggestionsCallback: (pattern) {
                  return CitiesServiceC.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  this._textController.text = suggestion;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return '';
                  }else{
                    return null;
                  }
                },
                onSaved: (value) => this._selectedCity = value,
              ),
              /* new TextField(
                decoration:
                    new InputDecoration.collapsed(hintText: "Enviar Mensaje"),
                controller: _textController,
                onSubmitted: _handleSubmitted,
              ),*/
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        new Divider(
          height: 1.0,
        ),
        new Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _textComposerWidget(),
        ),
      ],
    );
  }


  void GetChatList() async {
    String us = "88";

    helpe = new SharedPreferencesHelper();
    myUsID = await helpe.myUserID();
    myImagePath = await helpe.myFhotoPath();

    if(myImagePath==null||myImagePath==""){
      myImagePath="resources/images/taxi.png";
      //AssetImage avata=AssetImage("resources/images/taxi.png");

    }else{

      // FileImage avata= new FileImage(new File(myImagenPaths));

    }

    String URLchat=URL_Server+"Mensajeria/chat_cord.jsp?action=update&nick=${widget.id}&movile=${widget.id}&isMovil=ok";
    // log("URLchat $URLchat");
    final response = await http.post(URLchat,body:
    {"user":"$myUsID","tag":"turno"});
    log("response GetChatList:  ");
    // log(response.body.trim());

    //  List< dynamic>  jsonRespon=json.decode(response.body);
    var ObjRespuest=json.decode(response.body);

    var items = ObjRespuest['items'];
    _messages = <ChatMessageC>[];
    // String success=ObjRespuest[0]['success'].toString();
    try {
      setState(() {

        for(var mesa in items){

          //log(mesa.toString());

          bool yaEsta=false;
          ChatMessageC message = new ChatMessageC(
              text      : mesa['message'],
              emisor    : mesa['user'],
              fechaHora : mesa['date'],
              myName    : myUsID,
              imagePath : myImagePath,
              id        : mesa['id']
          );
          /*  for(var mmd in _messages){
        if( mmd.id == mesa['id']){
          yaEsta=true;
         }
      }*/
          // if(!_messages.contains(message)) {/**/
          /*  if(!yaEsta) {*/
          _messages.add( message);
          conta++;
          //log("se inserta message $conta");
          /* }else{
      //log("Se omite pues ya esta...");
    }*/
          //}else{

          // log("Se omite por que ya estaba.. ");
          // }/**/
        }

      });




    }catch(ersf){
      log("Error GetChatList..");
      throw Exception("Error on GetChatList");

    }

  }




  void PostChatMsg(String texto) async {

    helpe = new SharedPreferencesHelper();
    String MyUserIDs = await helpe.myUserID();
    print("ID: $MyUserIDs");
    String us = "88";


    String URLchat=URL_Server+"Mensajeria/chat_cord.jsp?action=insert&nick=$MyUserIDs&movile=${widget.id}&message=$texto&isMovil=ok";
    // log("URLchat $URLchat");

    final response = await http.post(URLchat,body:
    {"user":"$us","tag":"turno"});
    //log("response GetChatList:  ");
    log(response.body.trim());

    //  List< dynamic>  jsonRespon=json.decode(response.body);
    var ObjRespuest=json.decode(response.body);

    var items = ObjRespuest['items'];
    _messages = <ChatMessageC>[];
    // String success=ObjRespuest[0]['success'].toString();

    try {


      setState(() {
        for(var mesa in items) {
          ChatMessageC message = new ChatMessageC(
              text: mesa['message'],
              emisor: mesa['user'],
              fechaHora: mesa['date'],
              myName: myUsID,
              imagePath: myImagePath,
              id: mesa['id']
          );



          _messages.add(message);

          conta++;
        }
      });






    }catch(ersf){
      log("Error GetChatList..");
      throw Exception("Error on GetChatList");

    }

  }




  static const timeout = const Duration(seconds: 5);
  static const ms = const Duration(milliseconds: 1);

  startTimeout([int milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return new Timer.periodic(duration, handleTimeout);
  }

  void handleTimeout(Timer timef){

    GetChatList();
    //GetMiTurnoyEstado();
    debugPrint(timef.tick.toString());
    print("Se inicia el getData Chat... ");
    //time.cancel();
  }



  @override
  void dispose() {

    time.cancel();
    log("cancelando timer chat..");
    super.dispose();
  }
}

class CitiesServiceC {
  static final List<String> cities = [
    'Conductor no llega',
    'Problemas con la mercancia',
    'Vetado',
    'Error en seleccion de codigo',
    'Problemas de conexion'
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
