import 'package:filament_left/Screens/settings/help.dart';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/languages/language.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/editParams.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/style/formStyle.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:filament_left/screens/settings/presetProfiles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit extends StatefulWidget{
  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit>{
  @override
  void initState() {
    super.initState();
    if(ActiveProfile.profile != null){
      if(EditForm.nameController.text != ActiveProfile.profile.name){
        EditForm.nameController.text = ActiveProfile.profile.name;
      }
      if(EditForm.innerController.text != ActiveProfile.profile.inner.toString()){
        EditForm.innerController.text = ActiveProfile.profile.inner.toString();
      }
      if(EditForm.widthController.text != ActiveProfile.profile.width.toString()){
        EditForm.widthController.text = ActiveProfile.profile.width.toString();
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  var validForm = false;
  var profileName;
  var profileInner;
  var profileWidth;

  SharedPreferences prefs;
  getPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }

   



  editingTitle(Profile profile){
    if(profile == null){
      return SizedBox(height: 1);
    }
    else if(profile.filamentType == null){
      return SizedBox(height: 1);
    }
    return Text("Currently Editing:\n${profile.name} - ${profile.filamentSize}mm ${profile.filamentType}", style: basicLargeBlack, textAlign: TextAlign.center,);
  }


  @override
  Widget build(BuildContext context) {
    getPrefs();

    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(ActiveProfile.isEditing ? langMap()['edit'] : langMap()['add'], style: pageHeader,),
                    SizedBox(width: 55)
                  ]
                ),
              ),

              Form(
                key: _formKey,
                child:Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.width*.17),
                        editingTitle(ActiveProfile.profile),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            InkWell(
                              onTap: (){
                                analytics.logEvent(name: "lookAtPresets",);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PresetProfiles()),
                                );
                              },
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text(langMap()['commonPresets'], style: basicLargeBlack,),
                                    SizedBox(width: 7),
                                    Icon(Icons.open_in_new, size: 40,)
                                  ]
                                )
                              ),
                            ),
                            SizedBox(height:40),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30,),
                              alignment: Alignment.centerLeft,
                              child: Text(langMap()['profileName'], style: basicMediumBlack),
                            ),
                            SizedBox(height:10),
                            Container(
                              padding: EdgeInsets.only(left:30, right: 30),
                              child: TextFormField(
                                // initialValue: ActiveProfile.profile.name,
                                controller: EditForm.nameController,
                                decoration: textInputDecoration.copyWith(hintText: 'name'),
                                validator: (val) {
                                  if (val.isEmpty || val == "" || val == null) {
                                    return langMap()['valReq'];
                                  }
                                  
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() => profileName = val);
                                  
                                },
                              ),
                            ),

                            SizedBox(height: 40),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30),
                              alignment: Alignment.centerLeft,
                              child: Text(langMap()['innerDiamEdit'], style: basicMediumBlack),
                            ),
                            SizedBox(height:10),
                            Container(
                              padding: EdgeInsets.only(left:30, right: 30),
                              child: TextFormField(
                                // initialValue: ActiveProfile.profile.inner.toString(),
                                controller: EditForm.innerController,
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
                                  setState(() => profileInner = int.parse(val));
                                  
                                },
                              ),
                            ),

                            SizedBox(height: 40),

                            Container(
                              padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(langMap()["spoolWidth"], style: basicMediumBlack),
                            ),

                            Container(
                              padding: EdgeInsets.only(left:30, right: 30),
                              child: TextFormField(
                                // initialValue: ActiveProfile.profile.wudth.toString(),
                                controller: EditForm.widthController,
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
                                  setState(() => profileWidth = int.parse(val));
                                  
                                },
                              ),
                            ),
                            SizedBox(height: 40),
                            // Container(
                            //   padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(langMap()['spoolWeight'], style: basicMediumBlack),
                            // ),
                            // Container(
                            //   padding: EdgeInsets.only(left:30, right: 30),
                            //   child: TextFormField(
                            //     // initialValue: ActiveProfile.profile.wudth.toString(),
                            //     controller: EditForm.widthController,
                            //     keyboardType:  TextInputType.number,
                            //     decoration: textInputDecoration.copyWith(hintText: langMap()['initWeight']),
                            //     validator: (val) {
                            //       if (val.isEmpty || val == "" || val == null) {
                            //         return langMap()['valReq'];
                            //       }
                            //       if(int.parse(val) == null) {
                            //         return langMap()['intOnly'];
                            //       }
                            //       return null;
                            //     },
                            //     onChanged: (val) {
                            //       setState(() => profileWidth = int.parse(val));
                                  
                            //     },
                            //   ),
                            // ),
                            // SizedBox(height: 40),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30,),
                              alignment: Alignment.centerLeft,
                              child: Text(langMap()['filSize'], style: basicMediumBlack),
                            ),
                            SizedBox(height:10),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text(langMap()['1.75'], style: basicBlack,),
                                  Switch(
                                    value: EditForm.filament, 
                                    onChanged: (val){
                                      setState(() {
                                        EditForm.filament = val;
                                      });
                                    }
                                  ),
                                  Text(langMap()['2.85'], style: basicBlack,),
                                ]
                              ),
                            ),
                            SizedBox(height:40),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30,),
                              alignment: Alignment.centerLeft,
                              child: Text("${langMap()['filType']}:", style: basicMediumBlack),
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
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                  iconEnabledColor: darkBlue,
                                  dropdownColor: blue,
                                  validator: (value) => value == null ? langMap()['filReq'] : null,
                                  value: EditForm.filamentType,
                                  hint: Text(
                                    langMap()['filType'],
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
                                      EditForm.filamentType = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            

                            SizedBox(height: 25),

                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: (){
                                  if (_formKey.currentState.validate()) {
                                    if(ActiveProfile.isEditing){
                                      if(EditForm.name == null){
                                        EditForm.name = EditForm.nameController.text;
                                      }
                                      if(EditForm.inner == null){
                                        EditForm.inner = int.parse(EditForm.innerController.text);
                                      }
                                      if(EditForm.width == null){
                                        EditForm.width = int.parse(EditForm.widthController.text);
                                      }
                                      Profile profile = Profile(
                                        id: ActiveProfile.profile.id,
                                        name: EditForm.name,
                                        inner: EditForm.inner,
                                        width: EditForm.width,
                                        filamentSize: EditForm.filament ? 2.85 : 1.75,
                                        filamentType: EditForm.filamentType,
                                      );
                                      // print(profile.toMap());
                                      setState(() {
                                        DatabaseProviderProfile.db.update(profile).then(
                                          (storedProfile) => BlocProvider.of<ProfileBloc>(context).add(
                                            UpdateProfile(ActiveProfile.index, profile),
                                          ),
                                        );
                                      });
                                    }
                                    else{
                                      print("name: " + EditForm.nameController.text);
                                      if(EditForm.name == null){
                                        EditForm.name = EditForm.nameController.text;
                                      }
                                      if(EditForm.inner == null){
                                        EditForm.inner = int.parse(EditForm.innerController.text);
                                      }
                                      if(EditForm.width == null){
                                        EditForm.width = int.parse(EditForm.widthController.text);
                                      }
                                      Profile profile = Profile(
                                        name: EditForm.name,
                                        inner: EditForm.inner,
                                        width: EditForm.width,
                                        filamentSize: EditForm.filament ? 2.85 : 1.75,
                                        filamentType: EditForm.filamentType,
                                      );
                                      print("profile:" + profile.name);
                                      setState(() {
                                        DatabaseProviderProfile.db.insert(profile).then(
                                          (storedProfile) => BlocProvider.of<ProfileBloc>(context).add(
                                            AddProfile(storedProfile),
                                          ),
                                        );
                                      });
                                    }
                                    EditForm.nameController.text = "";
                                    EditForm.innerController.text = "";
                                    EditForm.widthController.text = "";
                                    EditForm.filamentType = null;
                                    // EditForm.width = null;
                                    // EditForm.inner = null;
                                    // EditForm.filament = null;
                                    // EditForm.filamentType = null;
                                    analytics.logEvent(name: "saveProfile", parameters: {"isEditing": ActiveProfile.isEditing.toString()});
                                    Navigator.pop(context);
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
                                  child: Text(ActiveProfile.isEditing ? langMap()['save'] : langMap()['add'], style: basicWhite,)
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            ActiveProfile.isEditing ? 
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: (){
                                    DatabaseProviderProfile.db.delete(ActiveProfile.profile.id).then((_) {
                                      BlocProvider.of<ProfileBloc>(context).add(
                                        DeleteProfile(ActiveProfile.index),
                                      );
                                    });
                                    analytics.logEvent(name: "deleteProfile");
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left:70, right:70,),
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    
                                    decoration: BoxDecoration(
                                      color: red,
                                      borderRadius: BorderRadius.circular(10),
                                      // boxShadow: [
                                      //   BoxShadow(color: Colors.green, spreadRadius: 3),
                                      // ],
                                    ),
                                    child: Text(langMap()['del'], style: basicWhite,)
                                  ),
                                ),
                              )
                              
                              : 

                              SizedBox(height:1), 



                            SizedBox(height: 25),
                            InkWell(
                              child: Text(langMap()['helpMsr'], style: basicBlack,),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Help()),
                                );
                              },
                            ),
                            SizedBox(height: 25),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
}