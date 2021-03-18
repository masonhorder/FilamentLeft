import 'package:filament_left/Screens/settings/help.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/editParams.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/style/formStyle.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:filament_left/screens/settings/presetProfiles.dart';

class Edit extends StatefulWidget{
  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit>{

  final _formKey = GlobalKey<FormState>();
  var validForm = false;



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
    if(ActiveProfile.profile != null){
      EditForm.nameController.text = ActiveProfile.profile.name;
      EditForm.innerController.text = ActiveProfile.profile.inner.toString();
      EditForm.widthController.text = ActiveProfile.profile.width.toString();
    }
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: CurrentDevice.hasNotch ? 36 : 10),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Container(
                      width: 55,
                      child: IconButton(icon: Icon(Icons.chevron_left, color: darkFontColor,), onPressed: (){ Navigator.pop(context);}, iconSize: 50)
                    ),
                    Text(ActiveProfile.isEditing ? "Edit" : "Add", style: pageHeader,),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PresetProfiles()),
                                );
                              },
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    Text("Common Spool Presets"),
                                    SizedBox(width: 7),
                                    Icon(Icons.open_in_new, size: 18,)
                                  ]
                                )
                              ),
                            ),
                            SizedBox(height:40),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30,),
                              alignment: Alignment.centerLeft,
                              child: Text("Profile Name:", style: basicMediumBlack),
                            ),
                            SizedBox(height:10),
                            Container(
                              padding: EdgeInsets.only(left:30, right: 30),
                              child: TextFormField(
                                controller: EditForm.nameController,
                                decoration: textInputDecoration.copyWith(hintText: 'name'),
                                validator: (val) {
                                  if (val.isEmpty || val == "" || val == null) {
                                    return 'this value is required';
                                  }
                                  
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() => EditForm.name = val);
                                  
                                },
                              ),
                            ),

                            SizedBox(height: 40),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30),
                              alignment: Alignment.centerLeft,
                              child: Text("Inner Diameter of The Spool(mm):", style: basicMediumBlack),
                            ),
                            SizedBox(height:10),
                            Container(
                              padding: EdgeInsets.only(left:30, right: 30),
                              child: TextFormField(
                                controller: EditForm.innerController,
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
                                  setState(() => EditForm.inner = int.parse(val));
                                  
                                },
                              ),
                            ),

                            SizedBox(height: 40),

                            Container(
                              padding: EdgeInsets.only(left:30, right: 30, bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text("Width of The Spool(mm):", style: basicMediumBlack),
                            ),

                            Container(
                              padding: EdgeInsets.only(left:30, right: 30),
                              child: TextFormField(
                                controller: EditForm.widthController,
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
                                  setState(() => EditForm.width = int.parse(val));
                                  
                                },
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30,),
                              alignment: Alignment.centerLeft,
                              child: Text("Filament Size:", style: basicMediumBlack),
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
                                  Text("1.75mm", style: basicBlack,),
                                  Switch(
                                    value: EditForm.filament, 
                                    onChanged: (val){
                                      setState(() {
                                        EditForm.filament = val;
                                      });
                                    }
                                  ),
                                  Text("2.85mm", style: basicBlack,),
                                ]
                              ),
                            ),
                            SizedBox(height:40),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal:30,),
                              alignment: Alignment.centerLeft,
                              child: Text("Filament Type:", style: basicMediumBlack),
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
                                  validator: (value) => value == null ? 'Language Required' : null,
                                  value: EditForm.filamentType,
                                  hint: Text(
                                    'Filament Type',
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
                                      Profile profile = Profile(
                                        name: EditForm.name,
                                        inner: EditForm.inner,
                                        width: EditForm.width,
                                        filamentSize: EditForm.filament ? 2.85 : 1.75,
                                        filamentType: EditForm.filamentType,
                                      );
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
                                  child: Text(ActiveProfile.isEditing ? "Save Changes" : "Add", style: basicWhite,)
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
                                    child: Text("Delete", style: basicWhite,)
                                  ),
                                ),
                              )
                              
                              : 

                              SizedBox(height:1), 



                            SizedBox(height: 25),
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