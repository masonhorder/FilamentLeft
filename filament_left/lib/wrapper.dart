import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/screens/home.dart';
import 'package:filament_left/screens/setUp.dart';
import 'package:filament_left/screens/settings.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  WrapperState createState() => new WrapperState();
}

class WrapperState extends State<Wrapper> with AfterLayoutMixin<Wrapper> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool openedBefore = (prefs.getBool('seen') ?? false);

    if (!openedBefore) {
      await prefs.setBool('seen', true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new SetUp())
      );
    } 
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
            
      length: 2,
      // length: 3,
      child: new Scaffold(
        body: TabBarView(
          children: [
            Home(),
            Settings(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: CurrentDevice.hasNotch ? EdgeInsets.only(bottom:20) : null,
          child: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.analytics),
              ),
              // Tab(
              //   icon: new Icon(Icons.show_chart)
              // ),
              Tab(
                icon: new Icon(Icons.settings),
              ),
            ],
            labelColor: darkBlue,
            unselectedLabelColor: darkBlue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: darkBlue,
          )
          
        ),
      )
    );
  }
}
