import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BuyMore{
  static num size;
  static String brand;
  static String material;
  static List rgb;
}

buyMorePopUp(BuildContext context){
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference spoolLinks = FirebaseFirestore.instance.collection('spoolLinks');
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Buy More Spools", style: popUpTitle,), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          StreamBuilder<QuerySnapshot>(
            stream: spoolLinks.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(document.data()['full_name']),
                    subtitle: new Text(document.data()['company']),
                  );
                }).toList(),
              );
            },
          ),
        ]
      ),
      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Exit", style: basicDarkBlue,),
        ),
      ],
    ),
  );
}