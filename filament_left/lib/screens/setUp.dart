import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/languages/language.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/editParams.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/screens/settings/editProfile.dart';
import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetUp extends StatefulWidget {
  @override
  SetUpState createState() => new SetUpState();
}

class SetUpState extends State<SetUp>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children:[
                SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
                        
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text(langMap()['welc'], style: pageHeader,)),
                ),
                SizedBox(height: 70),
                Text(langMap()['welcTxt'], style: basicBlack, textAlign: TextAlign.center,),
                SizedBox(height: 30),
                Image.asset("assets/phone1.png", width: MediaQuery.of(context).size.width*.5,)
              ]
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  // Container(
                  //   width: 70,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       primary: darkBlue, // background
                  //     ),
                  //     child: Text("Back", style: basicSmallBlack,),
                  //     onPressed: (){
                  //       Navigator.of(context).pop();
                  //     }
                  //   ),
                  // ),
                  SizedBox(width:70),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: darkBlue,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkBlue, // background
                      ),
                      child: Text(langMap()['nxt'], style: basicSmallBlack,),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetUp1())
                        );
                      }
                    ),
                  ),
                ]
              ),
            ),
          ]
        )
      )
    );
  }
}











class SetUp1 extends StatefulWidget {
  @override
  SetUp1State createState() => new SetUp1State();
}

class SetUp1State extends State<SetUp1>{

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
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: BlocConsumer<ProfileBloc, List<Profile>>(
          listener: (BuildContext context, profileList) {},
          builder: (context, profileList) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children:[
                      SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
                              
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text(langMap()['addSpools'], style: pageHeader,)),
                      ),
                      SizedBox(height:15),
                      Text(langMap()['spoolDesc'], style: basicBlack, textAlign: TextAlign.center,),
                      Expanded(

                        child: Column(
                          children: [
                            // SizedBox(height: MediaQuery.of(context).size.height*.07),

                            Expanded(
                              child: profileList.length != 0 ? 
                                Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
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
                                                Text("${profileList[index].name} - ${profileList[index].filamentSize}${langMap()['mm']} ${profileList[index].filamentType}", style: basicSmallBlack, overflow: TextOverflow.ellipsis,),
                                                IconButton(color: darkFontColor, icon: Icon(Icons.edit), onPressed: (){
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
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: darkBlue, // background
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            ActiveProfile.isEditing = false;
                                            ActiveProfile.profile = null;
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Edit()),
                                          );
                                        }, 
                                        child: Text(langMap()['anthSpool'], style: basicWhite)
                                      ),
                                    ]
                                  )
                                )

                                :

                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Text(langMap()['noSpool'], style: basicDarkBlue,),
                                      SizedBox(height:10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: darkBlue, // background
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            ActiveProfile.isEditing = false;
                                            ActiveProfile.profile = null;
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Edit()),
                                          );
                                        }, 
                                        child: Text(langMap()['addSpool'], style: basicSmallBlack)
                                      ),
                                      SizedBox(height:100)
                                    ]
                                  )
                                ),
                            )
                          ]
                        )
                      )
                    ]
                  )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Container(
                        width: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: darkBlue, // background
                          ),
                          child: Text(langMap()['bk'], style: basicSmallBlack,),
                          onPressed: (){
                            Navigator.of(context).pop();
                          }
                        ),
                      ),
                      // SizedBox(width:70),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width:3),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: darkBlue,
                              shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width:3),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width:3),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: darkBlue, // background
                          ),
                          child: Text(langMap()['nxt'], style: basicSmallBlack,),
                          onPressed: (){
                            if(profileList.length == 0){
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(langMap()['cont'], style: popUpTitle,), 
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:[
                                      Container(
                                        child: SingleChildScrollView(
                                          child: Text(langMap()['uSure'], style: basicBlack,),
                                        )
                                      ),
                                    ]
                                  ),
                                  
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SetUp2())
                                        );
                                      },
                                      child: Text(langMap()['cont'], style: basicBlack,),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(langMap()['bk'], style: basicDarkBlue,),
                                    ),
                                  ],
                                ),
                              );
                            } else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SetUp2())
                              );
                            }
                          }
                        ),
                      ),
                    ]
                  ),
                ),
              ]
            );
          }
        )
      )
    );
  }
}


class SetUp2 extends StatefulWidget {
  @override
  SetUp2State createState() => new SetUp2State();
}

class SetUp2State extends State<SetUp2>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text(langMap()['calcing'], style: pageHeader,)),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children:[
                    
                    SizedBox(height: 70),
                    Image.asset("assets/phone2.png", width: MediaQuery.of(context).size.width*.5,),
                    SizedBox(height: 15),
                    Text(langMap()['calcDescription'], style: basicBlack, textAlign: TextAlign.center,),
                  ]
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Container(
                    width: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkBlue, // background
                      ),
                      child: Text(langMap()['bk'], style: basicSmallBlack,),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                    ),
                  ),
                  // SizedBox(width:70),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: darkBlue,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkBlue, // background
                      ),
                      child: Text(langMap()['nxt'], style: basicSmallBlack,),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetUp3())
                        );
                      }
                    ),
                  ),
                ]
              ),
            ),
          ]
        )
      )
    );
  }
}


class SetUp3 extends StatefulWidget {
  @override
  SetUp3State createState() => new SetUp3State();
}

class SetUp3State extends State<SetUp3>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text(langMap()['scanning'], style: pageHeader,)),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children:[
                    
                    SizedBox(height: 70),
                    Image.asset("assets/phone1-arrow.png", width: MediaQuery.of(context).size.width*.7,),
                    SizedBox(height: 15),
                    Text(langMap()['scanningDesc'], style: basicBlack, textAlign: TextAlign.center,),
                  ]
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Container(
                    width: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkBlue, // background
                      ),
                      child: Text(langMap()['bk'], style: basicSmallBlack,),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                    ),
                  ),
                  // SizedBox(width:70),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width:3),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: darkBlue,
                          shape: BoxShape.circle
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkBlue, // background
                      ),
                      child: Text(langMap()['done'], style: basicSmallBlack,),
                      onPressed: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    ),
                  ),
                ]
              ),
            ),
          ]
        )
      )
    );
  }
}