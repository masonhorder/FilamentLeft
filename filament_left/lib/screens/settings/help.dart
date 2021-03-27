import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {
  
  var validForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Container(
                    width: 55,
                    child: IconButton(icon: Icon(Icons.chevron_left, color: darkFontColor,), onPressed: (){ Navigator.pop(context);}, iconSize: 50)
                  ),
                  Text("Help", style: pageHeader,),
                  SizedBox(width: 55)
                ]
              ),
            ),

            


            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*.07),
                    Text("Measuring By Diameter", style: basicLargeDarkBlue,),
                    Image(image: AssetImage('assets/help-diam.png'), height: 500,),
                    SizedBox(height:120),
                    Text("Measuring By Circumference", style: basicLargeDarkBlue,),
                    Image(image: AssetImage('assets/help-circumference.png'), height: 500,),
                  ],
                )
              )
            )
          ],
        ),
      )
    );
  }
}