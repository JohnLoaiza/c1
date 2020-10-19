import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const String _name = "Pawan";

class ChatMessage extends StatelessWidget {
  final String text;
  final String emisor;
  final String fechaHora;
  final String myName;
  final String imagePath;
  final String id;
  ChatMessage({this.text,this.emisor,this.fechaHora,this.myName,this.imagePath,this.id});

  @override
  Widget build(BuildContext context) {
    return  (emisor.toLowerCase())==(myName.toLowerCase())?
    new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child:new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          getAvatarChat(30.0, 30.0),
          getTextChat(60.0, MediaQuery.of(context).size.width*0.7,text,fechaHora)

        ],
      ),
    )
        :
    new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.only(left: 40),
      child:new Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[


          getTextChatR(60.0, MediaQuery.of(context).size.width*0.7,text,fechaHora),
          getAvatarChatR(35.0, 35.0)

        ],
      ),
    )
    ;
  }



  Widget getTextChat(var height,var width,String texto,String fechaHora){
    return Container(
      // height: height,
      width: width,
      child: Material(
        color: Colors.green[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(height / 3),
          bottomRight: Radius.circular(height / 3),
          topRight: Radius.circular(height / 3),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15,left: 20,top: 10,bottom: 10),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                  children: <Widget>[
                    Container(
                        alignment:Alignment.bottomLeft,
                        padding: EdgeInsets.only(top: 2),
                        child:
                        Text(fechaHora,
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                              fontSize: 9.0
                          ),
                        )),
                    Container(
                        alignment:Alignment.bottomLeft,
                        child:
                        AutoSizeText(
                          texto,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0
                          ),
                        )
                    )
                  ]
              )
          ),
        ),
      ),
    );


  }
  Widget  getAvatarChat(var height,var width){
    return new Container(
      height: height,
      width: width,
      color:Colors.green[50],
      child: Material(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(height / 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: height,
              height: height,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  image: new FileImage(new File(imagePath)),
                  fit: BoxFit.cover,
                ),
                border: new Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }


  Widget getTextChatR(var height,var width,String texto,String fechaHora){
    return Container(
      //height: height,
      width: width,
      child: Material(
        color: Colors.blue[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(height / 3),
          bottomRight: Radius.circular(height / 3),
          topLeft: Radius.circular(height / 3),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 20,left: 15,top: 10,bottom: 10),
          child: Container(
              alignment: Alignment.bottomRight,
              child: Column(
                  children: <Widget>[
                    Container(
                        alignment:Alignment.bottomRight,
                        padding: EdgeInsets.only(top: 2),
                        child:

                        Text(fechaHora,
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                              fontSize: 9.0

                          ),
                        )),
                    Container(
                      alignment:Alignment.bottomRight,
                      child:
                      AutoSizeText(
                        texto,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,

                        ),
                      ),
                    )
                  ]
              )
          ),
        ),
      ),
    );


  }
  Widget  getAvatarChatR(var height,var width){
    return new Container(
      height: height,
      width: width,
      color:Colors.blue[50],
      child: Material(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(height / 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              width: height,
              height: height,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                /* image: new DecorationImage(
                  image: new FileImage(new File(imagePath)),
                  fit: BoxFit.cover,
                ),*/
                border: new Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
              ),
              child: new CircleAvatar(
                child: new Text(emisor[0]),
              ),
            ),
          ],
        ),
      ),
    );


  }




}
