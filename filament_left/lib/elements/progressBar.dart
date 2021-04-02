import 'package:filament_left/functions/functions.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';

progressBar(BuildContext context, int grams){
  getWidth(int grams){
    print("grams: $grams");
    if(grams == null){
      return 0.0;
    }
    if(grams < 0){
      return 0.0;
    }
    if(grams > 1000){
      return MediaQuery.of(context).size.width-60;
    }
    if(((MediaQuery.of(context).size.width-60)*(grams/1000)).roundToDouble() < 40){
      return 40.0;
    }
    return ((MediaQuery.of(context).size.width-60)*(grams/1000)).roundToDouble();
  }
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
    decoration: BoxDecoration(
      border: Border.all(
        color: darkFontColor,
        width: .7
      ),
      borderRadius: BorderRadius.circular(9),
      color: lightGrey
    ),
    child: Row(
      children:[
        Container(
          decoration: BoxDecoration(
            color: getColor(grams),
            borderRadius: BorderRadius.circular(9)
          ),
          height: 18, 
          width: getWidth(grams),
          child: Center(child:Text("${((grams/1000)*100).round()}%", style: basicSmallBlack,)),
        ),
      ]
    )
  );
} 