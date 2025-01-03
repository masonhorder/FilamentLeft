import 'package:filament_left/Screens/settings/filamentProfiles.dart';
import 'package:filament_left/Screens/settings/help.dart';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/bloc/measureBloc.dart';
import 'package:filament_left/bloc/optInBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/measureEvent.dart';
import 'package:filament_left/events/optInEvent.dart';
import 'package:filament_left/functions/openLinks.dart';
import 'package:filament_left/languages/language.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/measure.dart';
import 'package:filament_left/models/optIn.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  
  bool measureSwitch = false;
  SharedPreferences prefs;

  getPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }
   

  @override
  void initState() {
    super.initState();
    DatabaseProviderMeasure.db.getMeasures(context).then(
      (measureList) {
        BlocProvider.of<MeasureBloc>(context).add(SetMeasures(measureList));
      },
    );
    DatabaseProviderOptIn.db.getOptIns(context).then(
      (optInList) {
        BlocProvider.of<OptInBloc>(context).add(SetOptIns(optInList));
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    getPrefs();


    




    return Scaffold(
      body: BlocConsumer<OptInBloc, List<OptIn>>(
        listener: (BuildContext context, optInList) {},
        builder: (context, optInList) {
          return BlocConsumer<MeasureBloc, List<Measure>>(
            listener: (BuildContext context, profileList) {},
            builder: (context, measureList) {
              if(measureList.length != 0){
                measureSwitch = measureList[0].circumference == 1 ? true : false;
              }
              return Container(
                child: Column(
                  children: [
                    SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),

                    Text(langMap()['settings'], style: pageHeader,),
                    SizedBox(height: 15),
                    
                    

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*.07),



                            

                            

                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Profiles()),
                                );
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: whiteFontColor,
                                  border: Border(
                                    top: BorderSide(color: darkBlue, width: 1,),
                                    bottom: BorderSide(color: darkBlue, width: 1,),

                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left:40),
                                      child:Text(langMap()['spools'], style: basicLargeDarkBlue,),
                                    ),
                                    Container(
                                      width:50,
                                      child: Icon(Icons.keyboard_arrow_right, color: darkBlue,), 
                                    )
                                  ]
                                )
                              )
                            ),

                            SizedBox(height: 2),

                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Help()),
                                );
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: whiteFontColor,
                                  border: Border(
                                    top: BorderSide(color: darkBlue, width: 1,),
                                    bottom: BorderSide(color: darkBlue, width: 1,),

                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left:40),
                                      child:Text(langMap()['help'], style: basicLargeDarkBlue,),
                                    ),
                                    Container(
                                      width:50,
                                      child: Icon(Icons.keyboard_arrow_right, color: darkBlue,), 
                                    )
                                  ]
                                )
                              )
                            ),

                            SizedBox(height:2),

                            Container(
                              decoration: BoxDecoration(
                                color: whiteFontColor,
                                border: Border(
                                  top: BorderSide(color: darkBlue, width: 1,),
                                  bottom: BorderSide(color: darkBlue, width: 1,),

                                ),
                              ),
                              child: Column(
                                children:[
                                  SizedBox(height:6),

                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    // alignment: Alignment.centerLeft,
                                    child:Text(langMap()['defMsrBy'], style: basicMediumBlack,),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                        
                                      Text(langMap()['diam'], style: basicBlack,),
                                      Switch(
                                        value: measureSwitch, 
                                        onChanged: (val){
                                          setState(() {
                                            // print("switch");
                                            measureSwitch = measureSwitch ? false : true;
                                            Measure newMeasure = Measure(
                                              id: measureList[0].id,
                                              circumference: measureList[0].circumference == 1 ? 0 : 1,
                                            );
                                            DatabaseProviderMeasure.db.update(newMeasure).then(
                                              (measureList) {
                                                BlocProvider.of<MeasureBloc>(context).add(UpdateMeasure(0, newMeasure));
                                              },
                                            );

                                            DatabaseProviderMeasure.db.getMeasures(context).then(
                                              (measureList) {
                                                BlocProvider.of<MeasureBloc>(context).add(SetMeasures(measureList));
                                              },
                                            );
                                          });
                                        }
                                      ),
                                      Text(langMap()['circ'], style: basicBlack,),
                                    ]
                                  ),
                                ]
                              )
                            ),

                            SizedBox(height: 2),

                            Container(
                              decoration: BoxDecoration(
                                color: whiteFontColor,
                                border: Border(
                                  top: BorderSide(color: darkBlue, width: 1,),
                                  bottom: BorderSide(color: darkBlue, width: 1,),

                                ),
                              ),
                              child: Column(
                                children:[
                                  SizedBox(height:6),

                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    // alignment: Alignment.centerLeft,
                                    child:Text(langMap()['photoSharing'], style: basicMediumBlack,),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: optInList[0].optIn == 2 ? true : false, 
                                        onChanged: (value){
                                          OptIn optIn = OptIn(
                                            id: 1,
                                            optIn: value ? 2 : 1,
                                          );
                                          setState(() {
                                            DatabaseProviderOptIn.db.update(optIn).then(
                                              (measureList) {
                                                BlocProvider.of<OptInBloc>(context).add(UpdateOptIn(0, optIn));
                                              },
                                            );
                                          });

                                          DatabaseProviderOptIn.db.getOptIns(context).then(
                                            (optInList) {
                                              BlocProvider.of<OptInBloc>(context).add(SetOptIns(optInList));
                                            },
                                          );
                                          analytics.logEvent(name: "optIn", parameters: {"optedIn": value.toString()});
                                          
                                        }
                                      ),
                                      Text(langMap()['optIn'], style: basicBlack,)
                                    ]
                                  )
                                ]
                              )
                            ),


                            SizedBox(height: 2),


                            Container(
                              decoration: BoxDecoration(
                                color: whiteFontColor,
                                border: Border(
                                  top: BorderSide(color: darkBlue, width: 1,),
                                  bottom: BorderSide(color: darkBlue, width: 1,),

                                ),
                              ),
                              child: Column(
                                children:[
                                  SizedBox(height:6),

                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    child:Text(langMap()['defLang'], style: basicMediumBlack,),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(7),
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    decoration: BoxDecoration(
                                      // border: Border(
                                      //   bottom: BorderSide(color: darkBlue, width: 2.3),
                                      //   top: BorderSide(color: darkBlue, width: 2.3),
                                      //   right: BorderSide(color: darkBlue, width: 2.3),
                                      //   left: BorderSide(color: darkBlue, width: 2.3),
                                      // ),
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.white,
                                    ),
                                    child: Container(
                                      child: DropdownButtonFormField<String>(
                                        iconEnabledColor: darkBlue,
                                        dropdownColor: blue,
                                        value: prefs.getString("language"),
                                        hint: Text(
                                          'Language',
                                          style: basicDarkBlue,
                                        ),

                                        items: <String>['English', 'Spanish', 'French', 'German'].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) async{
                                          setState((){
                                            // print(value);
                                            prefs.setString("language", value);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]
                              )
                            ),

                            
                            

                            





                            SizedBox(height: 100),

                            InkWell(
                              onTap: () async {
                                helpSite();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: whiteFontColor,
                                  border: Border(
                                    top: BorderSide(color: darkBlue, width: 1,),
                                    bottom: BorderSide(color: darkBlue, width: 1,),

                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child:Text(langMap()['support'], style: basicLargeDarkBlue,),
                                    ),
                                  ]
                                )
                              )
                            ),







                            SizedBox(height: 2),

                            InkWell(
                              onTap: () async {
                                website();
                              },
                              
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: whiteFontColor,
                                  border: Border(
                                    top: BorderSide(color: darkBlue, width: 1,),
                                    bottom: BorderSide(color: darkBlue, width: 1,),

                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child:Text(langMap()['site'], style: basicLargeDarkBlue,),
                                    ),
                                  ]
                                )
                              )
                            ),
                            SizedBox(height:30),
                            Text(langMap()['promo']),
                            SizedBox(height:10),
                            Text(langMap()['credits'], textAlign: TextAlign.center,)
                          ]
                        ),
                      )
                    )
                  ],
                ),
              );
            }
          );
        }
      )
    );
  }
}