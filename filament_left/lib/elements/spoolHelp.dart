import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';

spoolHelp(BuildContext context){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Filament Spool Type Help", style: popUpTitle,), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            child: SingleChildScrollView(
              child: Text("This is used to indetify key measurements of the spool and making it so you only have to enter it once. You can add your own spool below.", style: basicBlack,),
            )
          ),
        ]
      ),
      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close", style: basicBlack,),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Add Spool", style: basicDarkBlue,),
        ),
      ],
    ),
  );
}