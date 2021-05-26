import 'dart:io';
import 'package:filament_left/bloc/measureBloc.dart';
import 'package:filament_left/bloc/optInBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/bloc/spoolBloc.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/sharedPrefs.dart';
import 'package:filament_left/style/globals.dart';
import 'package:filament_left/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String shortcut = "none";

  @override
  void initState() {
    super.initState();
    precacheImage(AssetImage("assets/example.JPG"), context);
    _fetch();
  }


  getDevice() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo =  await deviceInfo.androidInfo;
    // print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.utsname.machine}');  
    return iosInfo.utsname.machine;
  }

  Future<void> _fetch() async {
    List<String> iphones = [
      "iPhone10,3",
      "iPhone10,6",
      "iPhone11,2",
      "iPhone11,4",
      "iPhone11,6",
      "iPhone11,8",
      "iPhone12,1",
      "iPhone12,3",
      "iPhone12,5",
      "iPhone12,8",
      "iPhone13,1",
      "iPhone13,2",
      "iPhone13,3",
      "iPhone13,4",
      "x86_64",
    ];
    // if(getDevice() is in )
    bool bottomNotch = false;
    String device;
    if(Platform.isIOS){
      bottomNotch = iphones.contains(await getDevice());
      device = await getDevice();
    }
    SharedPrefs.prefs = await SharedPreferences.getInstance();
    setState(() {
      CurrentDevice.hasNotch = bottomNotch;
      CurrentDevice.device = device;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    //     //Get the height of the status bar (top margin)
    // final double topPadding = MediaQuery.of(context).padding.top;
    // //Get the height of the bottom black line (bottom margin)
    // final double bottomPadding = MediaQuery.of(context).padding.bottom;  

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // this one for android
      statusBarBrightness: Brightness.light// this one for iOS
    ));



    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc([]),
        ),
        BlocProvider<SpoolBloc>(
          create: (BuildContext context) => SpoolBloc([]),
        ),
        BlocProvider<MeasureBloc>(
          create: (BuildContext context) => MeasureBloc([]),
        ),
        BlocProvider<OptInBloc>(
          create: (BuildContext context) => OptInBloc([]),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Filament Left',
        
        theme: ThemeData(
          accentColor: darkBlue,
          scaffoldBackgroundColor: blue,
        ),
        home: Wrapper()
      ),
    );
  }
}