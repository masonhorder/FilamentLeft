import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/editParams.dart';
import 'package:filament_left/style/formStyle.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:filament_left/models/presets.dart';
import 'package:path/path.dart';

class PresetProfiles extends StatefulWidget{
  @override
  PresetProfilesState createState() => PresetProfilesState();
}

class PresetProfilesState extends State<PresetProfiles>{

  presetBox(BuildContext context, List preset){
    return Container(
      margin: EdgeInsets.symmetric(vertical:10),
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(preset[0], style: basicBlackBold,),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              setState(() {
                EditForm.nameController.text = preset[0];
                EditForm.name = preset[0];
                EditForm.innerController.text = preset[1].toString();
                EditForm.inner = preset[1];
                EditForm.widthController.text = preset[2].toString();
                EditForm.width = preset[2];
                EditForm.presetProfile = true;
                
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }



  List presets = Presets.presets;
  String searchTerm;



  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: CurrentDevice.hasNotch ? 36 : 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Container(
                    width: 55,
                    child: IconButton(icon: Icon(Icons.chevron_left, color: darkFontColor,), onPressed: (){ Navigator.pop(context);}, iconSize: 50)
                  ),
                  Container(
                    child:Text("Presets", style: pageHeader,),
                  ),
                  SizedBox(width: 55)
                ]
              ),
              SizedBox(height:10),
              Container(
                margin: EdgeInsets.symmetric(horizontal:15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: darkBlue, width:2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 9,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    Container(
                      width: MediaQuery.of(context).size.width*.7,
                    
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            searchTerm = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "search profiles",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){
                        if(searchTerm != null){
                          List similarPresets = [];
                          for(List preset in Presets.presets){
                            if(preset[0].toLowerCase().contains(searchTerm.toLowerCase())){
                              similarPresets.add(preset);
                            }
                          }
                          setState(() {
                            presets = similarPresets;
                          });
                        }
                      },
                    ),
                  ]
                ),
              ),
              
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: ListView.builder(
                    itemCount: presets.length,
                    itemBuilder: (context, index){
                      return presetBox(context, presets[index]);
                    },
                  )
                ),
              ),
              Container(
                child: Text("Share your Filament's presets: \nEmail masonhorder.dev@gmail.com with the spool dimensions", style: basicSmallBlack, textAlign: TextAlign.center,)
              ),
                
              SizedBox(height: 20)

            ],
          ),
        )
      )
    );
  }
}