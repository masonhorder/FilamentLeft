import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';

submit30Photos(BuildContext context) {
  int index = 0;
  if(index == 0){
    photoUpload(context, index);
    index++;
  }
  if(index > 0 && index < 31){
    photoUpload(context, index);
    index++;
  }
  if(index ==  32){
    return null;
  }
}


photoUpload(BuildContext context, int index){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Photo ${index.toString()}/30", style: popUpTitle,), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            child: SingleChildScrollView(
              child: Text("Thanks so much for your help! You are helping make the model better. Please understand that if you cancel anytime you will lose your position and all photos that you took.", style: basicBlack,),
            )
          ),
        ]
      ),
      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: basicBlack,),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Next", style: basicDarkBlue,),
        ),
      ],
    ),
  );
}

startScreen(BuildContext context){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Submit Photos", style: popUpTitle,), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            child: SingleChildScrollView(
              child: Text("Thanks so much for your help! You are helping make the model better. Please understand that if you cancel anytime you will lose your position and all photos that you took.", style: basicBlack,),
            )
          ),
        ]
      ),
      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: basicBlack,),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Next", style: basicDarkBlue,),
        ),
      ],
    ),
  );
}


doneScreen(BuildContext context){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Thanks!", style: popUpTitle,), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            child: SingleChildScrollView(
              child: Text("Thanks so much for your help! You are helping make the model better. Please understand that if you cancel anytime you will lose your position and all photos that you took.", style: basicBlack,),
            )
          ),
        ]
      ),
      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: basicBlack,),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Next", style: basicDarkBlue,),
        ),
      ],
    ),
  );
}