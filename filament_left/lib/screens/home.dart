import 'package:filament_left/Screens/camera.dart';
import 'package:filament_left/Screens/settings/help.dart';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/bloc/measureBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/elements/buyMorePopUp.dart';
import 'package:filament_left/elements/progressBar.dart';
import 'package:filament_left/elements/spoolHelp.dart';
import 'package:filament_left/events/measureEvent.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/functions/functions.dart';
import 'package:filament_left/languages/language.dart';
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
            // padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
            margin: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child:Text(langMap()['innerDiamEdit'], style: basicMediumBlack,),
                ),
                IconButton(color: darkFontColor, icon: Icon(Icons.help), onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help()),
                  );
                })
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'inner diameter'),
              validator: (val) {
                if (val.isEmpty || val == "" || val == null) {
                  return langMap()['valReq'];
                }
                if(int.parse(val) == null) {
                  return langMap()['intOnly'];
                }
                return null;
              },
              onChanged: (val) {
                setState(() => CalculateForm.inner = int.parse(val));
                if(CalculateForm.inner != null && CalculateForm.filamentType != null && CalculateForm.width != null && CalculateForm.outer != null){
                  setState(() {
                    analytics.logEvent(name: "calculate");
                    CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                    CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                  });
                }
                
              },
            ),
          ),

          SizedBox(height: 40),

          Container(
            // padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
            margin: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child:Text(langMap()['spoolWidth'], style: basicMediumBlack,),
                ),
                IconButton(color: darkFontColor, icon: Icon(Icons.help), onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help()),
                  );
                })
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            child: TextFormField(
              keyboardType:  TextInputType.number,
              decoration: textInputDecoration.copyWith(hintText: 'width of the spool'),
              validator: (val) {
                if (val.isEmpty || val == "" || val == null) {
                  return langMap()['valReq'];
                }
                if(int.parse(val) == null) {
                  return langMap()['intOnly'];
                }
                return null;
              },
              onChanged: (val) {
                setState(() => CalculateForm.width = int.parse(val));
                if(CalculateForm.inner != null && CalculateForm.filamentType != null && CalculateForm.width != null && CalculateForm.outer != null){
                  setState(() {
                    analytics.logEvent(name: "calculate");
                    CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                    CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                  });
                }
                
              },
            ),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            alignment: Alignment.centerLeft,
            child: Text(langMap()['filSize'], style: basicMediumBlack),
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
                Text(langMap()['1.75'], style: basicBlack,),
                Switch(
                  value: CalculateForm.filament, 
                  onChanged: (val){
                    setState(() {
                      CalculateForm.filament = val;
                    });
                    if(CalculateForm.inner != null && CalculateForm.filamentType != null && CalculateForm.width != null && CalculateForm.outer != null){
                      setState(() {
                        analytics.logEvent(name: "calculate");
                        CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                        CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                      });
                    }
                  }
                ),
                Text(langMap()['2.85'], style: basicBlack,),
              ]
            ),
          ),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30,),
            alignment: Alignment.centerLeft,
            child: Text(langMap()['filType'], style: basicMediumBlack),
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
                validator: (value) => value == null ? langMap()['filReq'] : null,
                value: CalculateForm.filamentType,
                hint: Text(
                  langMap()['slctType'],
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
                  if(CalculateForm.inner != null && CalculateForm.filamentType != null && CalculateForm.width != null && CalculateForm.outer != null){
                    setState(() {
                      analytics.logEvent(name: "calculate");
                      CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                      CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                    });                 
                  }
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text(CalculateForm.value, style: basicLargeBlack,),
          SizedBox(height: 10,),
          progressBar(context, CalculateForm.grams),
          SizedBox(height: 15,),
          InkWell(
            onTap: (){
              BuyMore.brand = CalculateForm.profileName;
              BuyMore.material = CalculateForm.filamentType;
              BuyMore.size = CalculateForm.filament ? 2.85 : 1.75;
              buyMorePopUp(context);
            }, 
            child: Container(
              padding: EdgeInsets.all(10),
              width: 140,
              decoration: BoxDecoration(
                color: getColor(CalculateForm.grams),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(langMap()['buyMore'], style: basicWhite,),
                  SizedBox(width:8),
                  Icon(Icons.open_in_new, color: whiteFontColor, size: 18,)
                ],
              ),
            )
          ),
        ]
      );
    }
    return SizedBox(height: 1);
  }
  circumference(bool circumference){
    if(circumference){
      return langMap()['circ'];
    }
    return langMap()['diam'];
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
                      SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),

                      Text(langMap()['filamentLeft'], style: pageHeader,),
                      SizedBox(height: 30),
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
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(langMap()['filTypeFull'], style: basicMediumBlack,),
                                      IconButton(color: darkFontColor, icon: Icon(Icons.help), onPressed: (){
                                        return spoolHelp(context);
                                      })
                                    ]
                                  ),
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
                                    validator: (value) => value == null ? langMap()['filReq'] : null,
                                    value: CalculateForm.profile,
                                    hint: Text(
                                      langMap()['slctSpool'],
                                      style: basicDarkBlue,
                                    ),
                                    items: dropDownList.map((var value) {
                                      if(value == "other"){
                                        return new DropdownMenuItem<String>(
                                          value: "other",
                                          child: new Text(langMap()['entrVals'], style: basicBlack, overflow: TextOverflow.ellipsis,),
                                        );
                                      }
                                      return new DropdownMenuItem<String>(
                                        
                                        value: value.id.toString(),
                                        child: new Text("${value.name} - ${value.filamentSize}${langMap()['mm']} ${value.filamentType}", style: basicDarkBlue, overflow: TextOverflow.ellipsis,),
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
                                            CalculateForm.profileName = profile.name;
                                          }
                                        }
                                        setState(() {
                                          useProfile = true;
                                        });
                                        
                                      }
                                      setState((){
                                        // print(value);
                                        CalculateForm.profile = value;
                                      });
                                      if(CalculateForm.outer != null){
                                        setState(() {
                                          analytics.logEvent(name: "calculate");
                                          CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                                          CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                                        });
                                      }
                                      

                                    },
                                  )
                                ),
                                
                                SizedBox(height: 40),

                                Container(
                                  // padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child:Text("${langMap()['outer']} ${circumference(CalculateForm.circumference)} ${langMap()['remain']}", style: basicMediumBlack,),
                                      ),
                                      IconButton(color: darkFontColor, icon: Icon(Icons.help), onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Help()),
                                        );
                                      })
                                    ]
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.only(left:30, right: 30),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: textInputDecoration.copyWith(hintText: '${langMap()['outer']} ${circumference(CalculateForm.circumference).toLowerCase()}'),
                                    validator: (val) {
                                      if (val.isEmpty || val == "" || val == null) {
                                        return langMap()['valReq'];
                                      }
                                      if(int.parse(val) == null) {
                                        return langMap()['intOnly'];
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() => CalculateForm.outer = int.parse(val));
                                      if(CalculateForm.profile != null && useProfile){
                                        setState(() {
                                          analytics.logEvent(name: "calculate");
                                          CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                                          CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                                        });                                      
                                      }
                                      if(!useProfile && CalculateForm.inner != null && CalculateForm.filamentType != null && CalculateForm.width != null && CalculateForm.outer != null){
                                        setState(() {
                                          analytics.logEvent(name: "calculate");
                                          CalculateForm.value = "${langMap()['mtrsLeft']} ${filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round()}${langMap()['m']} \n${langMap()['grmsLeft']} ${metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round()}${langMap()['g']}";
                                          CalculateForm.grams = metersToGrams(filamentLeft(CalculateForm.outer, CalculateForm.inner, CalculateForm.width, CalculateForm.filament ? 2.85 : 1.75, CalculateForm.circumference).round(), CalculateForm.filamentType, CalculateForm.filament).round();
                                        });
                                        
                                      }
                                    },
                                  ),
                                ),

                                SizedBox(height: 40),
                          
                                extraForm(useProfile),

                                // SizedBox(height:10),
                                // InkWell(
                                //   child: Text("Get Help Measuring", style: basicBlack,),
                                //   onTap: (){
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (context) => Help()),
                                //     );
                                //   },
                                // ),
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
            analytics.logEvent(name: "openScanner");
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