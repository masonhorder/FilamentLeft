import 'package:filament_left/Screens/camera.dart';
import 'package:filament_left/Screens/settings/help.dart';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/bloc/measureBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/measureEvent.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/functions/functions.dart';
import 'package:filament_left/models/calculateForm.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/measure.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/style/formStyle.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';





class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {






  
  final _formKey = GlobalKey<FormState>();
  var validForm = false;
  bool useProfile = true;

  extraForm(bool useProfile){
    if(!useProfile){
      return Column(
        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            alignment: Alignment.centerLeft,
            child: Text("Inner Diameter of The Spool(mm):", style: basicMediumBlack),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'inner diameter'),
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
          ),

          SizedBox(height: 40),

          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            alignment: Alignment.centerLeft,
            child: Text("Width of The Spool(mm):", style: basicMediumBlack),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            child: TextFormField(
              keyboardType:  TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'width of the spool'),
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
                setState(() => CalculateForm.width = int.parse(val));
                
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            alignment: Alignment.centerLeft,
            child: Text("Filament Size:", style: basicMediumBlack),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: darkBlue, width: 2.3),
                top: BorderSide(color: darkBlue, width: 2.3),
                right: BorderSide(color: darkBlue, width: 2.3),
                left: BorderSide(color: darkBlue, width: 2.3),
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("1.75mm", style: basicBlack,),
                Switch(
                  value: CalculateForm.filament, 
                  onChanged: (val){
                    setState(() {
                      CalculateForm.filament = val;
                    });
                  }
                ),
                Text("2.85mm", style: basicBlack,),
              ]
            ),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            alignment: Alignment.centerLeft,
            child: Text("Filament Type:", style: basicMediumBlack),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: darkBlue, width: 2.3),
                top: BorderSide(color: darkBlue, width: 2.3),
                right: BorderSide(color: darkBlue, width: 2.3),
                left: BorderSide(color: darkBlue, width: 2.3),
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Container(
              // width: 200,
              child: DropdownButtonFormField<String>(
                iconEnabledColor: darkBlue,
                dropdownColor: blue,
                validator: (value) => value == null ? 'Language Required' : null,
                value: CalculateForm.filamentType,
                hint: Text(
                  'Select Filament Type',
                  style: basicDarkBlue,
                ),

                items: <String>['PLA', 'ABS', 'ASA', 'PETG', "Nylon", "PC", "HIPS", "PVA", "TPU", "PMMA", "Copper Fill"].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState((){
                    print(value);
                    CalculateForm.filamentType = value;
                  });
                },
              ),
            ),
          ),
        ],
      );
    }
    else{
      return SizedBox(height: 1,);
    }
  }

  result(){
    if(CalculateForm.value != ""){
      return Text(CalculateForm.value, style: basicMediumDarkBlue,);
    }
    return SizedBox(height: 1);
  }
  circumference(bool circumference){
    if(circumference){
      return "Cirumference";
    }
    return "Diameter";
  }

  @override
  void initState() {
    super.initState();
    DatabaseProviderProfile.db.getProfiles(context).then(
      (profileList) {
        BlocProvider.of<ProfileBloc>(context).add(SetProfiles(profileList));
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
                      SizedBox(height: CurrentDevice.hasNotch ? 36 : 10),

                      Text("Filament Left", style: pageHeader,),
                      SizedBox(height: 10),
                      result(),
                      SizedBox(height: 15),
                      
                      

                      Form(
                        key: _formKey,
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                
                                
                                
                                SizedBox(height: 40),


                                Container(
                                  padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Text("Outer ${circumference(CalculateForm.circumference)} of Filament Remaining(mm):", style: basicMediumBlack),
                                ),

                                Container(
                                  padding: EdgeInsets.only(left:30, right: 30),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: textInputDecoration.copyWith(hintText: 'outer ${circumference(CalculateForm.circumference).toLowerCase()}'),
                                    validator: (val) {
                                      if (val.isEmpty || val == "" || val == null) {
                                        return 'this value is required';
                                      }
                                      if(int.parse(val) == null) {
                                        return 'integer only';
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() => CalculateForm.outer = int.parse(val));
                                    },
                                  ),
                                ),



                                SizedBox(height:30),


                                // Container(
                                //   padding: EdgeInsets.all(2),
                                //   margin: EdgeInsets.symmetric(horizontal: 30),
                                //   decoration: BoxDecoration(
                                //     border: Border(
                                //       bottom: BorderSide(color: darkBlue, width: 2.3),
                                //       top: BorderSide(color: darkBlue, width: 2.3),
                                //       right: BorderSide(color: darkBlue, width: 2.3),
                                //       left: BorderSide(color: darkBlue, width: 2.3),
                                //     ),
                                //     borderRadius: BorderRadius.circular(10),
                                //     color: Colors.white,
                                //   ),
                                //   child:Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children:[
                                //       Text("Use Prestet Profile: ", style: basicBlack,),
                                //       Switch(
                                //         value: useProfile, 
                                //         onChanged: (val){
                                //           setState(() {
                                //             useProfile = val;
                                //           });
                                //         }
                                //       ),
                                //     ]
                                //   ),
                                // ),

                                SizedBox(height: 20),
                                // formExtension(profileList, useProfile),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  alignment: Alignment.centerLeft,
                                  child:Text("Profile:", style: basicMediumBlack,),
                                ),
                                SizedBox(height:10),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: darkBlue, width: 2.3),
                                      top: BorderSide(color: darkBlue, width: 2.3),
                                      right: BorderSide(color: darkBlue, width: 2.3),
                                      left: BorderSide(color: darkBlue, width: 2.3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child:DropdownButtonFormField<String>(
                                    isExpanded:true,
                                    iconEnabledColor: darkBlue,
                                    dropdownColor: Colors.white,
                                    validator: (value) => value == null ? 'Profile Required' : null,
                                    value: CalculateForm.profile,
                                    hint: Text(
                                      'Select a Profile',
                                      style: basicDarkBlue,
                                    ),
                                    items: dropDownList.map((var value) {
                                      if(value == "other"){
                                        return new DropdownMenuItem<String>(
                                          value: "other",
                                          child: new Text("Custom", style: basicBlack, overflow: TextOverflow.ellipsis,),
                                        );
                                      }
                                      return new DropdownMenuItem<String>(
                                        
                                        value: value.id.toString(),
                                        child: new Text("${value.name} - ${value.filamentSize}mm ${value.filamentType}", style: basicDarkBlue, overflow: TextOverflow.ellipsis,),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if(value == "other"){
                                        setState(() {
                                          useProfile = false;
                                        });
                                      }
                                      else{
                                        for(Profile profile in profileList){
                                          if(profile.id == int.parse(value)){
                                            CalculateForm.filament = profile.filamentSize == 1.75 ? false : true;
                                            CalculateForm.inner = profile.inner;
                                            CalculateForm.width = profile.width;
                                            CalculateForm.filamentType = profile.filamentType;
                                          }
                                        }
                                        setState(() {
                                          useProfile = true;
                                        });
                                        
                                      }
                                      setState((){
                                          print(value);
                                          CalculateForm.profile = value;
                                        });
                                      

                                    },
                                  )
                                ),
                                SizedBox(height: 40),
                          
                                extraForm(useProfile),

                                SizedBox(height: 40,),

                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: (){
                                      analytics.logEvent(name: "calculate");
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          CalculateForm.value = "Meters Left(approx.): ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}m \nGrams Left: ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}g";
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:70, right:70,),
                                      padding: EdgeInsets.only(top: 15, bottom: 15),
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.circular(10),
                                        // boxShadow: [
                                        //   BoxShadow(color: Colors.green, spreadRadius: 3),
                                        // ],
                                      ),
                                      child: Text("Calculate", style: basicWhite,)
                                    )
                                  ),
                                ),
                                SizedBox(height:10),
                                InkWell(
                                  child: Text("Get Help Measuring", style: basicBlack,),
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Help()),
                                    );
                                  },
                                ),
                                SizedBox(height: 25),
                              ]
                            )
                          ),
                        )
                      )
                    ],
                  );
                }
              );
            }
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Camera()
              )
            );
          },
          child: Icon(Icons.camera_alt, color: blue,),
          backgroundColor: darkBlue
        ),
      ),
    );
  }

}