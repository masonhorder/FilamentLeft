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






  
  final _formKey = GlobalKey<FormState>();
  var validForm = false;
  bool useProfile = true;

  @override
  void initState() {
    super.initState();
    DatabaseProviderProfile.db.getProfiles(context).then(
      (profileList) {
        BlocProvider.of<ProfileBloc>(context).add(SetProfiles(profileList));
      },
    );
    DatabaseProviderSpool.db.getSpools(context).then(
      (profileList) {
        BlocProvider.of<SpoolBloc>(context).add(SetSpools(profileList));
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
                  return BlocConsumer<MeasureBloc, List<Measure>>(
                    listener: (BuildContext context, spoolList) {},
                    builder: (context, spoolList) {
                  
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

                          Center(child:Text("Spools", style: pageHeader,)),
                          SizedBox(height: 15),
                          
                          ListView.builder(
                            itemBuilder: (context, index){
                              return CircularProgressIndicator();
                            }
                          )

                          
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

          },
          child: Icon(Icons.add, color: blue,),
          backgroundColor: darkBlue
        ),
      ),
    );
  }

}