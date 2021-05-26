import 'dart:math';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/languages/language.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filament_left/functions/functions.dart';

class BuyMore{
  static num size;
  static String brand;
  static String material;
  static List rgb;
}

buyMorePopUp(BuildContext context){
  // print(BuyMore.rgb);
  int index = 1;
  CollectionReference spoolLinks = FirebaseFirestore.instance.collection('spoolLinks');
  showDialog(
    // barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(langMap()['buySpools'], style: popUpTitle,), 
      content: StreamBuilder<QuerySnapshot>(
        stream: spoolLinks.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          analytics.logEvent(name: "buyMoreOpen");
          bool itemFits = true;
          List adjustedDocument = [];
          String message;
          List sizes = [];
          List brands = [];
          List materials = [];


          if (snapshot.hasError) {
            // print(snapshot.error);
            return Center(child: Text(langMap()['smthWrong'], style: basicBlackBold,));
          }


          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                CircularProgressIndicator(),
                Center(child: Text(langMap()['loading'], style: basicBlackBold,))
              ]
            );
          }





          if(snapshot.connectionState != ConnectionState.waiting && !snapshot.hasError){
            for(var item in snapshot.data.docs.toList()){
              if(!sizes.contains(item.data()['size'])){
                sizes.add(item.data()['size']);
              }
              if(!brands.contains(item.data()['brand'])){
                brands.add(item.data()['brand']);
              }
              if(!materials.contains(item.data()['material'])){
                materials.add(item.data()['material']);
              }
            }
            
            if(!sizes.contains(BuyMore.size) || materials.contains(BuyMore.material) || brands.contains(BuyMore.brand)){
              if(!brands.contains(BuyMore.brand)){
                // print("brand:" + BuyMore.brand);
                message = langMap()['brandSwitch'];
                BuyMore.brand = "Hatchbox";
              }
              if(!sizes.contains(BuyMore.size)){
                message = langMap()['noSize'];
              }
              if(!materials.contains(BuyMore.material)){
                message = langMap()['noMat'];
              }
              
            }
            for(var item in snapshot.data.docs.toList()){
              index++;
              itemFits = true;
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
              // print(itemFits);
              if(itemFits){
                adjustedDocument.add(item.data());
                // print("adding");
              }
              
            }


            
            if(BuyMore.rgb !=null){
              List scores = [];
              var colorDocument = adjustedDocument;
              for(int i = 0; i < colorDocument.length; i++){
                int score = (sqrt((pow(BuyMore.rgb[0] - colorDocument[i]['rgb'][0],2))) + sqrt((pow(BuyMore.rgb[1] - colorDocument[i]['rgb'][1],2))) + sqrt((pow(BuyMore.rgb[2] - colorDocument[i]['rgb'][2],2)))).round();
                scores.add([i, score]);
              }
              print(scores);
              scores.sort((a,b) => a[1].compareTo(b[1]));
              adjustedDocument = [];
              for(List score in scores){
                adjustedDocument.add(colorDocument[score[0]]);
              } 
            }
          }
          print("Total Spools: ${index.toString()}");


          if(adjustedDocument.length == 0){
            return Center(child: Text(langMap()['noSimSpools'], style: basicBlackBold,));
          }
          return Container(
            child: Column(
              children: [
                Text("${BuyMore.brand} ${BuyMore.material} ${BuyMore.size}${langMap()['mm']}", style: basicBlackBold,),
                SizedBox(height:10),
                message == null ?
                  SizedBox(height: 1)
                  :
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.6), spreadRadius: 3, blurRadius: 7)],
                    ),
                    child: Text("$message", style: basicSmallBlack,),
                  ),
                SizedBox(height:10),
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
                                IconButton(color: darkFontColor, icon: Icon(Icons.open_in_browser), onPressed: (){
                                  openLink(adjustedDocument[index]['link']);
                                  analytics.logEvent(name: "openLink", parameters: {"brand": adjustedDocument[index]['brand'], "color": adjustedDocument[index]['name'], "material": adjustedDocument[index]['material'], "size": adjustedDocument[index]['size']});
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
          child: Text(langMap()['close'], style: basicDarkBlue,),
        ),
      ],
    ),
  );
}