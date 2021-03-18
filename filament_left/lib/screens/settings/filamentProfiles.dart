

import 'package:filament_left/Screens/settings/editProfile.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/editParams.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profiles extends StatefulWidget {
  @override
  ProfilesState createState() => ProfilesState();
}

class ProfilesState extends State<Profiles> {
  
  var validForm = false;

  @override
  void initState() {
    super.initState();
    DatabaseProviderProfile.db.getProfiles(context).then(
      (profileList) {
        BlocProvider.of<ProfileBloc>(context).add(SetProfiles(profileList));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocConsumer<ProfileBloc, List<Profile>>(
          listener: (BuildContext context, profileList) {},
          builder: (context, profileList) {
            return Column(
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
                      Text("Profiles", style: pageHeader, overflow: TextOverflow.ellipsis,),
                      SizedBox(width: 55)
                    ]
                  ),
                ),

                


                Expanded(

                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*.07),

                      Expanded(
                        child: profileList.length != 0 ? 
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            itemCount: profileList.length,
                            itemBuilder: (BuildContext context, int index){
                              print(profileList[index].inner);
                              return Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${profileList[index].name} - ${profileList[index].filamentSize}mm ${profileList[index].filamentType}", style: basicSmallBlack, overflow: TextOverflow.ellipsis,),
                                    IconButton(icon: Icon(Icons.edit), onPressed: (){
                                      ActiveProfile.index = profileList.indexOf(profileList[index]);
                                      ActiveProfile.isEditing = true;
                                      ActiveProfile.profile = profileList[index];
                                      EditForm.name = profileList[index].name;
                                      EditForm.inner = profileList[index].inner;
                                      EditForm.width = profileList[index].width;
                                      EditForm.filamentType = profileList[index].filamentType;
                                      EditForm.filament = profileList[index].filamentSize == 2.85 ? true : false;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Edit()),
                                      );
                                    })
                                  ],
                                ),
                              );
                            },
                          )

                          :

                          Center(child: Text("No profiles set up yet", style: basicDarkBlue,)),
                      )
                    ]
                  )
                )
              ]
            );
          }
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            ActiveProfile.isEditing = false;
            ActiveProfile.profile = null;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Edit()),
          );
        },
        child: Icon(Icons.add, color: blue,),
        backgroundColor: darkBlue
      ),
    );
  }
}
            