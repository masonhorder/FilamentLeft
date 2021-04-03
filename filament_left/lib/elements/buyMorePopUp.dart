import 'package:filament_left/elements/flushBar.dart';
import 'package:filament_left/functions/functions.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class BuyMore{
  static num size;
  static String brand;
  static String material;
  static List rgb;
}

buyMorePopUp(BuildContext context){
  CollectionReference spoolLinks = FirebaseFirestore.instance.collection('spoolLinks');
  showDialog(
    // barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Buy More Spools", style: popUpTitle,), 
      content: StreamBuilder<QuerySnapshot>(
        stream: spoolLinks.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          bool itemFits = true;
          List adjustedDocument = [];
          String message;



          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Something Went Wrong, Try Again Later", style: basicBlackBold,));
          }


          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                CircularProgressIndicator(),
                Center(child: Text("Loading", style: basicBlackBold,))
              ]
            );
          }





          if(snapshot.connectionState != ConnectionState.waiting && !snapshot.hasError){
            for(var item in snapshot.data.docs.toList()){
              itemFits = true;
              print("${BuyMore.brand} - ${item.data()['brand']}");
              print("${BuyMore.size} - ${item.data()['size']}");
              print("${BuyMore.material} - ${item.data()['material']}");
              if(BuyMore.brand != null){
                if(BuyMore.brand != item.data()['brand']){
                  itemFits = false;
                  // print("brand false");
                }
              }
              if(BuyMore.size != null){
                if(BuyMore.size != item.data()['size']){
                  itemFits = false;
                  // print("size false");
                }
              }
              if(BuyMore.material != null ){
                if(BuyMore.material != item.data()['material']){
                  itemFits = false;
                  // print("material false");
                }
              }
              print(itemFits);
              if(itemFits){
                adjustedDocument.add(item.data());
                print("adding");
              }
              print(adjustedDocument);
            }
          }


          if(adjustedDocument.length == 0){
           return Center(child: Text("No similar spools found", style: basicBlackBold,));
          }
          return Container(
            child: Column(
              children: [
                Text("${BuyMore.brand} ${BuyMore.material} ${BuyMore.size}mm", style: basicBlackBold,),
                SizedBox(height:20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: (50*adjustedDocument.length).roundToDouble(),
                      width: 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: adjustedDocument.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(adjustedDocument[index]['rgb'][0], adjustedDocument[index]['rgb'][1], adjustedDocument[index]['rgb'][2], 1),
                                        borderRadius: BorderRadius.circular(3)
                                      ),
                                      child: SizedBox(height:32, width: 32,),
                                    ),
                                    SizedBox(width:5),
                                    Container(width: 160, child: Text("${adjustedDocument[index]['brand']} ${adjustedDocument[index]['name']}", style: basicSmallBlack, overflow: TextOverflow.ellipsis,)),
                                  ]
                                ),
                                // SizedBox(width:5),
                                IconButton(icon: Icon(Icons.copy), onPressed: (){
                                   Clipboard.setData(new ClipboardData(text: adjustedDocument[index]['link'])).then((_){
                                     Navigator.pop(context);
                                     showFloatingFlushbar(context, "Link Copied to Clipboard", adjustedDocument[index]['link']);
                                  });
                                })
                              ]
                            )
                          );
                        },
                      )
                    )
                  )
                )
              ]
            )
          );
        },
      ),

      
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close", style: basicDarkBlue,),
        ),
      ],
    ),
  );
}