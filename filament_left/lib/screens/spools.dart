import 'package:filament_left/bloc/measureBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/bloc/spoolBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/measureEvent.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/events/spoolEvent.dart';
import 'package:filament_left/models/calculateForm.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/measure.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/models/spool.dart';
import 'package:filament_left/style/formStyle.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';





class Spools extends StatefulWidget {
  @override
  SpoolsState createState() => SpoolsState();
}

class SpoolsState extends State<Spools> {
  var validForm = false;
  bool useProfile = true;




  addSpool(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        
        backgroundColor: Colors.white,
        title: Text("Filament Scanning", style: popUpTitle,), 
        content: Container(
          child: SingleChildScrollView(
            child: Column(
              children:[
                Text("Spool Name:", style: basicBlackBold,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Spool Color'),
                  validator: (val) {
                    if (val.isEmpty || val == "" || val == null) {
                      return 'this value is required';
                    }
                    if(int.parse(val) == null) {
                      return 'integers only';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() => CalculateForm.inner = int.parse(val));
                    
                  },
                ),
                SizedBox(height:10),
                Text("Spool Profile:", style: basicBlackBold,),
                // Container(
                //   padding: EdgeInsets.all(9),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: whiteFontColor,
                //   ),
                //   width: MediaQuery.of(context).size.width*.7,
                //   child: DropdownButtonFormField<String>(
                //     isExpanded:true,
                //     iconEnabledColor: darkBlue,
                //     dropdownColor: Colors.white,
                //     validator: (value) => value == null ? 'Profile Required' : null,
                //     value: Scan.profileName,
                //     hint: Text(
                //       'Select a Profile',
                //       style: basicDarkBlue,
                //     ),
                //     items: profileList.map((var value) {
                //       return new DropdownMenuItem<String>(
                        
                //         value: value.id.toString(),
                //         child: new Text("${value.name} - ${value.filamentSize}mm ${value.filamentType}", style: basicDarkBlue, overflow: TextOverflow.ellipsis,),
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //       setState((){
                //         // print(value);
                //         Scan.profileName = value;
                //         for(var document in profileList){
                //           if(document.id.toString() == value){
                //             Scan.profile = document;
                //           }
                //         }
                //       });
                //       if(byteData != null){
                //           Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
                //           Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
                //           Scan.diameter = (Scan.profile.width/ratio).round();
                //         }
                //     },
                //   )
                // ),
              ]
            )
          )
        ),
        
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: basicDarkBlue,),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Add", style: basicDarkBlue,),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    DatabaseProviderProfile.db.getProfiles(context).then(
      (profileList) {
        BlocProvider.of<ProfileBloc>(context).add(SetProfiles(profileList));
      },
    );
    DatabaseProviderSpool.db.getSpools(context).then(
      (spoolList) {
        BlocProvider.of<SpoolBloc>(context).add(SetSpools(spoolList));
      },
    );
    DatabaseProviderMeasure.db.getMeasures(context).then(
      (measureList) {
        BlocProvider.of<MeasureBloc>(context).add(SetMeasures(measureList));
      },
    );
  }

  @override
  Widget build(BuildContext context) {


      

    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: Container(
          child: BlocConsumer<ProfileBloc, List<Profile>>(
            listener: (BuildContext context, profileList) {},
            builder: (context, profileList) {
              return BlocConsumer<MeasureBloc, List<Measure>>(
                listener: (BuildContext context, profileList) {},
                builder: (context, measureList) {
                  return BlocConsumer<SpoolBloc, List<Spool>>(
                    listener: (BuildContext context, spoolList) {},
                    builder: (context, spoolList) {
                      // print("spool list: " + spoolList.toString());
                      if(spoolList.toString() == "[]" || spoolList == null){
                        // print("no spools");
                        return Column(
                          children: [
                            SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
                            
                            Center(child:Text("Spools", style: pageHeader,)),
                            SizedBox(height: MediaQuery.of(context).size.height*.26),
                            Text("No spools created yet, add one below", style: basicBlackBold,)
                          ]
                        );
                      }
                      // print(measureList);
                      if(measureList.length != 0){
                        CalculateForm.circumference = measureList[0].circumference == 1 ? true : false;
                      }

                      List dropDownList = [];
                      for(Profile profile in profileList){
                        dropDownList.add(profile);
                      }
                      dropDownList.add("other");

                      return Column(
                        children: [
                          SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
                          
                          Center(child:Text("Spools", style: pageHeader,)),
                          SizedBox(height: 15),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: spoolList.length,
                              itemBuilder: (context, index){
                                print(spoolList.length);
                                return Text(spoolList[index].toString());
                              }
                            )
                          ),

                          
                        ],
                      );
                    }
                  );
                }
              );
            }
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addSpool(context);
          },
          child: Icon(Icons.add, color: blue,),
          backgroundColor: darkBlue
        ),
      ),
    );
  }

}