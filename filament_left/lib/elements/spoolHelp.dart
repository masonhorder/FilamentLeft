import 'package:filament_left/languages/language.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';

spoolHelp(BuildContext context){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(langMap()['spoolHelp'], style: popUpTitle,), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            child: SingleChildScrollView(
              child: Text(langMap()['shDesc'], style: basicBlack,),
            )
          ),
        ]
      ),
      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(langMap()['close'], style: basicBlack,),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(langMap()['addSpool'], style: basicDarkBlue,),
        ),
      ],
    ),
  );
}