import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/bloc/optInBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/elements/buyMorePopUp.dart';
import 'package:filament_left/elements/loading.dart';
import 'package:filament_left/elements/progressBar.dart';
import 'package:filament_left/events/optInEvent.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/functions/functions.dart';
import 'package:filament_left/languages/language.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/optIn.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/models/scan.dart';
import 'package:filament_left/models/scanVersion.dart';
import 'package:filament_left/style/globals.dart';
import 'package:camera/camera.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';






class Camera extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  File _image;
  Image imageType;
  num width;
  num height;
  List finalCoordinates = [];
  var memoryImageSize;
  Uint8List byteData;
  Uint8List originalByteData;
  bool popUpTriggered = false;
  double ratio;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  File imageFile;
  var rectImage;
  bool scanning = false;
  var rgb;
  var interpreter;
  List rotatedCoordinates = [];
  var finalImage;
  final firestoreInstance = FirebaseFirestore.instance;


  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera,ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }


  @override
  void initState() {
    // precacheImage(AssetImage("assets/example.JPG"), context);
    super.initState();
    _initializeCamera(); 
    DatabaseProviderProfile.db.getProfiles(context).then(
      (profileList) {
        BlocProvider.of<ProfileBloc>(context).add(SetProfiles(profileList));
      },
    );
    DatabaseProviderOptIn.db.getOptIns(context).then(
      (optInList) {
        BlocProvider.of<OptInBloc>(context).add(SetOptIns(optInList));
      },
    );
    // interpreter = await tfl.Interpreter.fromAsset('v15-model.tflite');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  List<double> rotateCoordinate(width, height, x, y){
    double maxX = width/2;
    double maxY = height/2;
    double oldX = x-maxX;
    double oldY = y-maxY;
    double newX;
    double newY;

    newX = oldY * -1;
    newY = oldX;

    newX += maxY;
    newY += maxX;
  
    return [newX, newY];
  }





  Future scanImage(File image) async {    
    setState(() {
      _image = image;
      imageType = Image.file(_image);
      final imageSize = ImageSizeGetter.getSize(FileInput(_image));
      height = imageSize.height;
      width = imageSize.width;
    });
    List convertedImage = await preConvertImage();
    List output = await recognize(convertedImage);
    await extractCoordinates(output);
    double startX = finalCoordinates[0];
    double startY = finalCoordinates[1];
    double endX = finalCoordinates[2];
    double endY = finalCoordinates[3];


    drawBox(image, startX, startY, endX, endY){
      img.Image rectangleConversion = img.decodeImage(byteData);
      image = img.drawRect(rectangleConversion, startX.toInt(), startY.toInt(), endX.toInt(), endY.toInt(), img.getColor(29, 204, 183));
      image = img.copyRotate(image, 90);
      image = img.encodePng(image);
      return image;
    }

    setState(() {
      ratio = (endY-startY)/(endX-startX);
      byteData = originalByteData.buffer.asUint8List();   
      rgb = getAvgColor(img.decodeImage(byteData));
      if(Scan.profile != null){
        Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
        Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
        Scan.diameter = (Scan.profile.width/ratio).round();
      }

      rotatedCoordinates.add(rotateCoordinate(width, height, startX.toInt(), startY.toInt()));
      rotatedCoordinates.add(rotateCoordinate(width, height, endX.toInt(), endY.toInt()));
      finalImage = img.decodeImage(byteData);
      finalImage = img.copyRotate(finalImage, 90);
      rectImage = drawBox(finalImage, finalCoordinates[0], finalCoordinates[1], finalCoordinates[2], finalCoordinates[3]);
      
    });

    
  }

  Future<List> recognize(List imageList) async {
    if(interpreter == null){
      interpreter = await tfl.Interpreter.fromAsset('v15-model.tflite');
    }
    imageCache.clear();
    var input = imageList.reshape([1,224,224,3]);
    List output = List.filled(1*4, "", growable: true).reshape([1,4]);
    interpreter.run(input, output);
    interpreter.close();
    return output;
  }


  Future<List> preConvertImage() async{
    // print("preconvert");
    Future<img.Image> getUiImage() async {
      final Uint8List assetImageByteData = await _image.readAsBytes();
      originalByteData = assetImageByteData;

      img.Image baseSizeImage = img.decodeImage(assetImageByteData);
      img.Image resizeImage = img.copyResize(baseSizeImage, height: 224, width: 224);
      return resizeImage;
    }
    img.Image image = await getUiImage();
    List oldArray = image.getBytes();
    List newArray = [];
    int index = 0;
    for(var item in oldArray){
      if(index % 4 != 0){
        newArray.add(item/255);
      }
      index++;
    }
    return newArray;
  }

  extractCoordinates(List output) async{
    finalCoordinates = [];
    finalCoordinates.add(output[0][0]*width);
    finalCoordinates.add(output[0][1]*height);
    finalCoordinates.add(output[0][2]*width);
    finalCoordinates.add(output[0][3]*height);
  }

  getAvgColor(img.Image image){
    List rgb = [];
    img.Image cropped = img.copyCrop(image, finalCoordinates[0].round(), finalCoordinates[1].round(), finalCoordinates[2].round()-finalCoordinates[0].round(), finalCoordinates[3].round()-finalCoordinates[1].round());
    int redBucket = 0;
    int greenBucket = 0;
    int blueBucket = 0;
    int pixelCount = 0;

    for (int y = 0; y < cropped.height; y++) {
      for (int x = 0; x < cropped.width; x++) {
        int c = cropped.getPixel(x, y);

        pixelCount++;
        redBucket += img.getRed(c);
        greenBucket += img.getGreen(c);
        blueBucket += img.getBlue(c);
      }
    }

    rgb.add((redBucket/pixelCount).round());
    rgb.add((greenBucket/pixelCount).round());
    rgb.add((blueBucket/pixelCount).round());
    return rgb;
  }






  takePhoto() async {
    File file = File((await _controller.takePicture()).path);
    
    //on camera button press  
    return file; //take photo
  }





  betaPopUp(BuildContext context) {
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
                Text("Please double check all scanned measurements!", style: basicBlack, textAlign: TextAlign.center,),
                Text("Example Photo:", style: basicBlackBold,),
                Image.asset("assets/example.JPG",)
              ]
            )
          )
        ),
        
        actions: <Widget>[
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     freePro();
          //   },
          //   child: Text("Submit Photos", style: basicDarkBlue,),
          // ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Try it out!", style: basicDarkBlue,),
          ),
        ],
      ),
    );
  }

  
  firstScanPopUp(BuildContext context, List optInList) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Share Data", style: popUpTitle,), 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Container(
              child: SingleChildScrollView(
                child: Text("If you are willing to share your photos from your scan please opt in. These photos will be used to help train future models. This has no cost to you and helps the model a ton!(you can change this option in settings if you need too)", style: basicBlack,),
              )
            ),
          ]
        ),
        
        actions: <Widget>[
          TextButton(
            onPressed: () {
              OptIn optIn = OptIn(
                id: 1,
                optIn: 1,
              );
              DatabaseProviderOptIn.db.update(optIn).then(
                (measureList) {
                  BlocProvider.of<OptInBloc>(context).add(UpdateOptIn(0, optIn));
                },
              );
              Navigator.pop(context);
              Future.delayed(Duration.zero, () => betaPopUp(context));
            },
            child: Text("Don't share", style: basicBlack,),
          ),
          TextButton(
            onPressed: () {
              OptIn optIn = OptIn(
                id: 1,
                optIn: 2,
              );
              DatabaseProviderOptIn.db.update(optIn).then(
                (measureList) {
                  BlocProvider.of<OptInBloc>(context).add(UpdateOptIn(0, optIn));
                },
              );
              Navigator.pop(context);
              Future.delayed(Duration.zero, () => betaPopUp(context));
            },
            child: Text("Share Photos", style: basicDarkBlue,),
          ),
        ],
      ),
    );
  }








  @override 
  Widget build(BuildContext context){

    return Scaffold(
      body: BlocConsumer<OptInBloc, List<OptIn>>(
        listener: (BuildContext context, optInList) {},
        builder: (context, optInList) {
          // if(Scan.meters != null){
          //   Scan.meters = null;
          //   Scan.grams = null;
          //   Scan.diameter = null;
          // }
          if(optInList.length != 0){
            if(optInList[0].optIn == 0){
              if(!popUpTriggered){
                // print(optInList);
                // print(optInList[0].optIn);
                popUpTriggered = true;
                Future.delayed(Duration.zero, () => firstScanPopUp(context, optInList));
              }
            }








            return BlocConsumer<ProfileBloc, List<Profile>>(
              listener: (BuildContext context, profileList) {},
              builder: (context, profileList) {
                if(!popUpTriggered){
                  popUpTriggered = true;
                  Future.delayed(Duration.zero, () => betaPopUp(context));
                }
                return Container(
                  child: Column(
                    children: [
  
                      
                      

                      Expanded(
                        // child: SingleChildScrollView(
                        child: Column(
                          children: [

                            scanning ? Container(
                              // width: MediaQuery.of(context).size.width *.5,
                              height: 400,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Loading(),
                                    Text("Running Scanning... this may take a few seconds")
                                  ],
                                )
                              )
                            )

                            :

                            rectImage == null 

                            ?


                            FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {



                                  return Stack(
                                    children: [

                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        child: ClipRect(
                                          child: OverflowBox(
                                            alignment: Alignment.center,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height,
                                                
                                                child: CameraPreview(_controller), // this is my CameraPreview
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),



                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [



                                            Column(
                                              children:[ 
                                                SizedBox(height: CurrentDevice.hasNotch ? 36 : 15),
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children:[
                                                      Container(
                                                        width: 55,
                                                        child: IconButton(icon: Icon(Icons.close, color: darkFontColor,), onPressed: (){Navigator.pop(context);}, iconSize: 50)
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(langMap()['scan'], style: pageHeader,),
                                                          SizedBox(width: 5),
                                                          Container(
                                                            child: Text("Beta", style: basicBlack,),
                                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 55,)

                                                      
                                                    ]
                                                  ),
                                                ),
                                              ]
                                            ),




                                            Column(
                                              children: [

                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape: CircleBorder(), 
                                                    primary: Colors.transparent
                                                  ),
                                                  child: Container(
                                                    width: 80,
                                                    height: 80,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: darkBlue,
                                                        width: 8
                                                      )
                                                    ),

                                                  ),
                                                  onPressed: () async{
                                                    setState(() {
                                                      scanning = true;
                                                    });
                                                    File tempFile = await takePhoto();
                                                    setState(() {
                                                      imageFile = tempFile;
                                                    });
                                                    await scanImage(imageFile);
                                                    if(Scan.profile != null){
                                                      Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
                                                      Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
                                                      Scan.diameter = (Scan.profile.width/ratio).round();
                                                      if(Scan.grams < 100){
                                                        Flushbar(
                                                          margin: EdgeInsets.all(5),
                                                          borderRadius: 8,
                                                          duration: Duration(seconds: 10),
                                                          icon: Icon(Icons.warning, color: Colors.red,),
                                                          // titleText: Text("Uh Oh, It looks like you are running low on ${Scan.profile.name} ${Scan.profile.filamentType}", style: basicRedBold,),
                                                          messageText: Text("It looks like you are running low on ${Scan.profile.name} ${Scan.profile.filamentType}", style: basicRedBold,),
                                                          mainButton: InkWell(
                                                            onTap: (){
                                                              print(Scan.profileName);
                                                              BuyMore.brand = Scan.name; 
                                                              BuyMore.material = Scan.profile.filamentType;
                                                              BuyMore.size = Scan.profile.filamentSize;
                                                              BuyMore.rgb = rgb;
                                                              buyMorePopUp(context);
                                                            }, 
                                                            child: Container(
                                                              padding: EdgeInsets.all(10),
                                                              width: 120,
                                                              decoration: BoxDecoration(
                                                                color: getColor(Scan.grams),
                                                                borderRadius: BorderRadius.circular(10)
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(langMap()['buyMore'], style: basicWhite,),
                                                                  // SizedBox(width:8),
                                                                  // Icon(Icons.open_in_new, color: whiteFontColor, size: 18,)
                                                                ],
                                                              ),
                                                            )
                                                          ),

                                                        )..show(context);
                                                      }
                                                    }
                                                    analytics.logEvent(name: "scan", parameters: {"optIn": optInList[0].optIn == 2 ? true : false});
                                                    uploadFile(await getImageFileFromAssets(rectImage), "output");
                                                    uploadFile(_image, "images");
                                                    if(optInList[0].optIn == 2){

                                                      var imageData = await uploadFile(_image, "scans");
                                                      firestoreInstance.collection("images").doc(imageData[1].toString()).set({
                                                        "fileLocation": imageData[0],
                                                        "scannedCoordinates": finalCoordinates,
                                                        "versionCode": ScanVersion.scanVersion,
                                                        "annotatedCoordinates": [null, null, null, null],
                                                        "status": 0,
                                                        "date": DateTime.now().millisecondsSinceEpoch
                                                      });                                     
                                                    }
                                                    setState(() {
                                                      scanning = false;
                                                    });
                                                  },
                                                ),
                                            
                                                SizedBox(height: 20,)
                                              ]
                                            )


                                          ],
                                        )
                                      ),
                                      

                                    ],
                                  );
                                  // return CameraPreview(_controller);
                                }
                                  
                                else {
                                  return Center(
                                    child: CircularProgressIndicator()
                                  ); 
                                }
                              },
                            )

                            :

                            Stack(
                              children: [
                                Image.memory(rectImage),
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [



                                      Column(
                                        children:[ 
                                          SizedBox(height: CurrentDevice.hasNotch ? 36 : 15),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:[
                                                Container(
                                                  width: 55,
                                                  child: IconButton(icon: Icon(Icons.close, color: whiteFontColor,), onPressed: (){Navigator.pop(context);}, iconSize: 50)
                                                ),
                                                Row(
                                                  children: [
                                                    Text(langMap()['scan'], style: basicLargeWhite,),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      child: Text("Beta", style: basicBlack,),
                                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 55,)

                                                
                                              ]
                                            ),
                                          ),
                                        ]
                                      ),




                                      // Column(
                                      //   children: [

                                      //     // InkWell(
                                      //     //   child: Container(
                                      //     //     padding: EdgeInsets.symmetric(horizontal: 30,vertical: 17),
                                      //     //     decoration: BoxDecoration(
                                      //     //       color: darkBlue,
                                      //     //       borderRadius: BorderRadius.circular(10)
                                      //     //     ),
                                      //     //     child: Text(langMap()['rescan']),
                                      //     //   ),
                                      //     //   onTap: () async {
                                      //     //     setState(() {
                                      //     //       rectImage = null;
                                      //     //     });
                                      //     //   },
                                      //     // ),
                                      
                                      //     SizedBox(height: 20,)
                                      //   ]
                                      // )


                                    ],
                                  )
                                ),
                                Scan.grams == null ?
                                  Container(
                                    decoration: BoxDecoration(
                                      color: red,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(7)
                                      ),
                                    ),
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.only(top: (rotatedCoordinates[0][1]/width)*MediaQuery.of(context).size.height, left:(rotatedCoordinates[1][0]/height)*MediaQuery.of(context).size.width),
                                    child: Column(
                                      children: [
                                        Text("Select a Spool!", style: basicSmallBlack,),
                                        
                                      ],
                                    ),
                                  )
                                  :
                                  Container(
                                    decoration: BoxDecoration(
                                      color: getColor(Scan.grams),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(7)
                                      ),
                                    ),
                                    padding: EdgeInsets.all(4),
                                    margin: EdgeInsets.only(top: (rotatedCoordinates[0][1]/width)*MediaQuery.of(context).size.height, left:(rotatedCoordinates[1][0]/height)*MediaQuery.of(context).size.width),
                                    child: Column(
                                      children: [
                                        Text("${Scan.profile.name} ${Scan.profile.filamentType}:", style: basicSmallBlack,),
                                        Text("${Scan.grams}g Remaining", style: basicSmallBlack,),
                                        Text("${Scan.meters}m Remaining", style: basicSmallBlack,),
                                        InkWell(
                                          onTap: (){
                                            print(Scan.profileName);
                                            BuyMore.brand = Scan.name; 
                                            BuyMore.material = Scan.profile.filamentType;
                                            BuyMore.size = Scan.profile.filamentSize;
                                            BuyMore.rgb = rgb;
                                            buyMorePopUp(context);
                                          }, 
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            width: 116,
                                            decoration: BoxDecoration(
                                              color: getColor(Scan.grams),
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
                                      ],
                                    ),
                                  ),
                                
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: profileList.length == 0 ?
                                          Text(langMap()['spoolReqStr'], style: basicBlack, textAlign: TextAlign.center,)
                                          :
                                          Container(
                                            padding: EdgeInsets.all(9),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: whiteFontColor,
                                            ),
                                            width: MediaQuery.of(context).size.width*.7,
                                            child: DropdownButtonFormField<String>(
                                              isExpanded:true,
                                              iconEnabledColor: darkBlue,
                                              dropdownColor: Colors.white,
                                              validator: (value) => value == null ? langMap()['spoolReq'] : null,
                                              value: Scan.profileName,
                                              hint: Text(
                                                langMap()['slctSpool'],
                                                style: basicDarkBlue,
                                              ),
                                              items: profileList.map((var value) {
                                                return new DropdownMenuItem<String>(
                                                  
                                                  value: value.id.toString(),
                                                  child: new Text("${value.name} - ${value.filamentSize}${langMap()['mm']} ${value.filamentType}", style: basicDarkBlue, overflow: TextOverflow.ellipsis,),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState((){
                                                  // print(value);
                                                  Scan.profileName = value;
                                                  for(var document in profileList){
                                                    if(document.id.toString() == value){
                                                      Scan.profile = document;
                                                      Scan.name = document.name;
                                                    }
                                                  }
                                                });
                                                if(byteData != null){
                                                    Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
                                                    Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
                                                    Scan.diameter = (Scan.profile.width/ratio).round();
                                                    if(Scan.grams < 100){
                                                      Flushbar(
                                                        margin: EdgeInsets.all(5),
                                                        borderRadius: 8,
                                                        duration: Duration(seconds: 10),
                                                        icon: Icon(Icons.warning, color: Colors.red,),
                                                        // titleText: Text("Uh Oh, It looks like you are running low on ${Scan.profile.name} ${Scan.profile.filamentType}", style: basicRedBold,),
                                                        messageText: Text("It looks like you are running low on ${Scan.profile.name} ${Scan.profile.filamentType}", style: basicRedBold,),
                                                        mainButton: InkWell(
                                                          onTap: (){
                                                            print(Scan.profileName);
                                                            BuyMore.brand = Scan.name; 
                                                            BuyMore.material = Scan.profile.filamentType;
                                                            BuyMore.size = Scan.profile.filamentSize;
                                                            BuyMore.rgb = rgb;
                                                            buyMorePopUp(context);
                                                          }, 
                                                          child: Container(
                                                            padding: EdgeInsets.all(10),
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                              color: getColor(Scan.grams),
                                                              borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(langMap()['buyMore'], style: basicWhite,),
                                                                // SizedBox(width:8),
                                                                // Icon(Icons.open_in_new, color: whiteFontColor, size: 18,)
                                                              ],
                                                            ),
                                                          )
                                                        ),

                                                      )..show(context);
                                                    }
                                                  }
                                              },
                                            )
                                          ),
                                      ),
                                    ]
                                  ),
                                ),
                              ],
                            ),



                            // SizedBox(height:10),

                            // profileList.length == 0 ?
                            //   Text(langMap()['spoolReqStr'], style: basicBlack, textAlign: TextAlign.center,)
                            //   :
                            //   Container(
                            //     padding: EdgeInsets.all(9),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       color: whiteFontColor,
                            //     ),
                            //     width: MediaQuery.of(context).size.width*.7,
                            //     child: DropdownButtonFormField<String>(
                            //       isExpanded:true,
                            //       iconEnabledColor: darkBlue,
                            //       dropdownColor: Colors.white,
                            //       validator: (value) => value == null ? langMap()['spoolReq'] : null,
                            //       value: Scan.profileName,
                            //       hint: Text(
                            //         langMap()['slctSpool'],
                            //         style: basicDarkBlue,
                            //       ),
                            //       items: profileList.map((var value) {
                            //         return new DropdownMenuItem<String>(
                                      
                            //           value: value.id.toString(),
                            //           child: new Text("${value.name} - ${value.filamentSize}${langMap()['mm']} ${value.filamentType}", style: basicDarkBlue, overflow: TextOverflow.ellipsis,),
                            //         );
                            //       }).toList(),
                            //       onChanged: (value) {
                            //         setState((){
                            //           // print(value);
                            //           Scan.profileName = value;
                            //           for(var document in profileList){
                            //             if(document.id.toString() == value){
                            //               Scan.profile = document;
                            //               Scan.name = document.name;
                            //             }
                            //           }
                            //         });
                            //         if(byteData != null){
                            //             Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
                            //             Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
                            //             Scan.diameter = (Scan.profile.width/ratio).round();
                            //             if(Scan.grams < 100){
                            //               Flushbar(
                            //                 margin: EdgeInsets.all(5),
                            //                 borderRadius: 8,
                            //                 duration: Duration(seconds: 10),
                            //                 icon: Icon(Icons.warning, color: Colors.red,),
                            //                 // titleText: Text("Uh Oh, It looks like you are running low on ${Scan.profile.name} ${Scan.profile.filamentType}", style: basicRedBold,),
                            //                 messageText: Text("It looks like you are running low on ${Scan.profile.name} ${Scan.profile.filamentType}", style: basicRedBold,),
                            //                 mainButton: InkWell(
                            //                   onTap: (){
                            //                     print(Scan.profileName);
                            //                     BuyMore.brand = Scan.name; 
                            //                     BuyMore.material = Scan.profile.filamentType;
                            //                     BuyMore.size = Scan.profile.filamentSize;
                            //                     BuyMore.rgb = rgb;
                            //                     buyMorePopUp(context);
                            //                   }, 
                            //                   child: Container(
                            //                     padding: EdgeInsets.all(10),
                            //                     width: 120,
                            //                     decoration: BoxDecoration(
                            //                       color: getColor(Scan.grams),
                            //                       borderRadius: BorderRadius.circular(10)
                            //                     ),
                            //                     child: Row(
                            //                       mainAxisAlignment: MainAxisAlignment.center,
                            //                       children: [
                            //                         Text(langMap()['buyMore'], style: basicWhite,),
                            //                         // SizedBox(width:8),
                            //                         // Icon(Icons.open_in_new, color: whiteFontColor, size: 18,)
                            //                       ],
                            //                     ),
                            //                   )
                            //                 ),

                            //               )..show(context);
                            //             }
                            //           }
                            //       },
                            //     )
                            //   ),
                          ]
                        )
                      )
                    ]
                  )
                );
              }
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
  

  result(){
    if(Scan.meters != null){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${langMap()['mtrsLeft']} ${Scan.meters}${langMap()['m']}", style: basicMediumDarkBlue,),
          Text("${langMap()['gramsLeft']} ${Scan.grams}${langMap()['g']}", style: basicMediumDarkBlue,),
          Text("${langMap()['prdctDiam']} ${Scan.diameter}${langMap()['mm']}", style: basicSmallBlack,),
          Text("${langMap()['prdctCirc']} ${Scan.diameter*3.14}${langMap()['mm']}", style: basicSmallBlack,),
          progressBar(context, Scan.grams),
          SizedBox(height: 15,),
          InkWell(
            onTap: (){
              print(Scan.profileName);
              BuyMore.brand = Scan.name; 
              BuyMore.material = Scan.profile.filamentType;
              BuyMore.size = Scan.profile.filamentSize;
              BuyMore.rgb = rgb;
              buyMorePopUp(context);
            }, 
            child: Container(
              padding: EdgeInsets.all(10),
              width: 140,
              decoration: BoxDecoration(
                color: getColor(Scan.grams),
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

        ],
      );
    }
    return SizedBox(height: 1);
  }
}








































