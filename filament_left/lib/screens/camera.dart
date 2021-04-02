import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:filament_left/analytics.dart';
import 'package:filament_left/bloc/optInBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/db/database_provider.dart';
import 'package:filament_left/elements/buyMorePopUp.dart';
import 'package:filament_left/elements/progressBar.dart';
import 'package:filament_left/events/optInEvent.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/functions/functions.dart';
import 'package:filament_left/functions/openLinks.dart';
import 'package:filament_left/models/currentDevice.dart';
import 'package:filament_left/models/optIn.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/models/scan.dart';
import 'package:filament_left/style/globals.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as pathMod;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart'; 






class Camera extends StatefulWidget {
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  File _image;
  Image imageType;
  var _recognition;
  var _path;
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
  String debugString = "debug:";
  Uint8List rectImage;

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
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }





  Future scanImage(File image) async {
    print("scan");
    
    setState(() {
      debugString += "\nscanning";
      _image = image;
      imageType = Image.file(_image);
      final imageSize = ImageSizeGetter.getSize(FileInput(_image));
      height = imageSize.height;
      width = imageSize.width;
      _path = image.path;
    });
    // print("preconvert");
    List converted = await preConvert();
    // await recognize(converted);
    await postConvert(await recognize(converted));
    double startX = finalCoordinates[0];
    double startY = finalCoordinates[1];
    double endX = finalCoordinates[2];
    double endY = finalCoordinates[3];


    ratio = (endY-startY)/(endX-startX);
    print(ratio);
    debugString += "\nratio: $ratio";

    setState(() {
      byteData = originalByteData.buffer.asUint8List();      
      if(Scan.profile != null){
        Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
        Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
        Scan.diameter = (Scan.profile.width/ratio).round();
      }
      img.Image rectangleConversion = img.decodeImage(byteData);
      rectImage = img.encodePng(img.drawRect(rectangleConversion, startX.toInt(), startY.toInt(), endX.toInt(), endY.toInt(), img.getColor(29, 204, 183)));
      // img.drawRect(dst, x1, y1, x2, y2, color)
    });

    
  }

  Future<List> recognize(List imageList) async {
    print("recognize");
    imageCache.clear();
    final interpreter = await tfl.Interpreter.fromAsset('v9-model.tflite');
    var input = imageList.reshape([1,224,224,3]);
    List output = List(1*4).reshape([1,4]);
    interpreter.run(input, output);
    print(output);
    interpreter.close();
    return output;
  }


  Future<List> preConvert() async{
    print("preconvert");
    debugString += "\npreconvert";
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

  postConvert(List output) async{
    finalCoordinates = [];
    print("postconvert");
    debugString += "\npost convert";
    int index = 0;
    
    finalCoordinates.add(output[0][0]*width);
    finalCoordinates.add(output[0][1]*height);
    finalCoordinates.add(output[0][2]*width);
    finalCoordinates.add(output[0][3]*height);
        
    print(finalCoordinates);
  }






  takePhoto() async {
    debugString += "\ntaking photo";
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
                child: Text("By continuing to use the scan feature you agree and understand that we will use your scanned photos to help train the future models. We do collect this data solely for the puprose of improving scanning, once the photo has been evaluated we will remove it from the database. This photo is not attached to your idenity at all, it is completely anonymous. Thanks for your understanding! You can opt out any time in settings!", style: basicBlack,),
              )
            ),
          ]
        ),
        
        actions: <Widget>[
          TextButton(
            onPressed: () {
              analytics.logEvent(name: "optIn", parameters: {"optedIn": "false"});
              // OptIn optIn = OptIn(
              //   id: 1,
              //   optIn: 1,
              // );
              // DatabaseProviderOptIn.db.update(optIn).then(
              //   (measureList) {
              //     BlocProvider.of<OptInBloc>(context).add(UpdateOptIn(0, optIn));
              //   },
              // );
              Navigator.pop(context);
              Navigator.pop(context);
              // Future.delayed(Duration.zero, () => betaPopUp(context));
            },
            child: Text("Cancel", style: basicBlack,),
          ),
          TextButton(
            onPressed: () {
              analytics.logEvent(name: "optIn", parameters: {"optedIn": "true"});
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
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.height / size.width;


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
            if(optInList[0].optIn == 0 || optInList[0].optIn == 1){
              if(!popUpTriggered){
                print(optInList);
                print(optInList[0].optIn);
                popUpTriggered = true;
                Future.delayed(Duration.zero, () => firstScanPopUp(context, optInList));
              }
            }




            // OptIn optIn = OptIn(
            //   id: 1,
            //   optIn: 0,
            // );
            // setState(() {
            //   DatabaseProviderOptIn.db.update(optIn).then(
            //     (measureList) {
            //       BlocProvider.of<OptInBloc>(context).add(UpdateOptIn(0, optIn));
            //     },
            //   );
            // });





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
                      SizedBox(height: CurrentDevice.hasNotch ? 36 : 28),
                      
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Container(
                              width: 55,
                              child: IconButton(icon: Icon(Icons.chevron_left, color: darkFontColor,), onPressed: (){Navigator.pop(context);}, iconSize: 50)
                            ),
                            Row(
                              children: [
                                Text("Scan", style: pageHeader,),
                                SizedBox(width: 5),
                                // Container(
                                //   child: Text("Beta", style: basicBlack,),
                                //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(20),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(width: 55,)

                            
                          ]
                        ),
                      ),
                      SizedBox(height: 10),
                      result(),
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                      
                      

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              rectImage == null 

                              ?

                              Column(
                                children:[
                                  SizedBox(height: 20),
                                  Container(
                                    child: Center(child: Text("Always double check measurements!", textAlign: TextAlign.center,)),
                                    width: MediaQuery.of(context).size.width*.9,
                                  ),
                                  SizedBox(height:30),
                                  FutureBuilder<void>(
                                    future: _initializeControllerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        // If the Future is complete, display the preview.
                                        // return Transform.scale(
                                        //   scale: deviceRatio/_controller.value.aspectRatio ,
                                        //   child: Center(
                                        //     child: AspectRatio(
                                        //       aspectRatio: _controller.value.aspectRatio,
                                        //       child: CameraPreview(_controller), //cameraPreview
                                        //     ),
                                        //   )
                                        // );


                                        return Container(
                                          width: MediaQuery.of(context).size.width*.5,
                                          height: MediaQuery.of(context).size.height*.5,
                                          child: ClipRect(
                                            child: OverflowBox(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width*.5,
                                                  height: MediaQuery.of(context).size.height*.5,
                                                  child: CameraPreview(_controller), // this is my CameraPreview
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                        // return CameraPreview(_controller);
                                      }
                                       
                                      else {
                                        return Center(
                                          child: CircularProgressIndicator()
                                        ); 
                                      }
                                    },
                                  ),
                                  SizedBox(height:3),
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 17),
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("Scan"),
                                    ),
                                    onTap: () async {
                                      File tempFile = await takePhoto();
                                      setState(() {
                                        imageFile = tempFile;
                                      });
                                      await scanImage(imageFile);
                                      if(Scan.profile != null){
                                        Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
                                        Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
                                        Scan.diameter = (Scan.profile.width/ratio).round();
                                      }
                                      analytics.logEvent(name: "scan");
                                      // if(optInList[0].optIn == 2){
                                      // upload file
                                      uploadFile(_image, "images");
                                      uploadFile(await getImageFileFromAssets(rectImage), "output");
                                      

                                      // }
                                    },
                                  ),
                                ]
                              )


                              :

                              Column(
                                children: [
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Image.memory(rectImage, width: (MediaQuery.of(context).size.width *.5)*2,),
                                  ),
                                  SizedBox(height:3),
                                  InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 17),
                                      decoration: BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text("Re-Scan"),
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        rectImage = null;
                                      });
                                    },
                                  ),
                                ],
                              ),


                              SizedBox(height:10),

                              profileList.length == 0 ?
                                Text("Atleast 1 Spool Type is required(add one in settings tab under \"Spools\")", style: basicBlack, textAlign: TextAlign.center,)
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
                                    validator: (value) => value == null ? 'Spool Type Required' : null,
                                    value: Scan.profileName,
                                    hint: Text(
                                      'Select a Spool Type',
                                      style: basicDarkBlue,
                                    ),
                                    items: profileList.map((var value) {
                                      return new DropdownMenuItem<String>(
                                        
                                        value: value.id.toString(),
                                        child: new Text("${value.name} - ${value.filamentSize}mm ${value.filamentType}", style: basicDarkBlue, overflow: TextOverflow.ellipsis,),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState((){
                                        // print(value);
                                        Scan.profileName = value;
                                        for(var document in profileList){
                                          if(document.id.toString() == value){
                                            Scan.profile = document;
                                          }
                                        }
                                      });
                                      if(byteData != null){
                                          Scan.meters = filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round();
                                          Scan.grams = metersToGrams(filamentLeft((Scan.profile.width/ratio).round(), Scan.profile.inner, Scan.profile.width, Scan.profile.filamentSize, false).round(), Scan.profile.filamentType, Scan.profile.filamentSize == 2.85 ? true : false).round();
                                          Scan.diameter = (Scan.profile.width/ratio).round();
                                        }
                                    },
                                  )
                                ),


                              
                              
                              // InkWell(
                              //   child: Text("Learn about submitting photos to get pro for free.", style: basicSmallDarkBlue,),
                              //   onTap: () {
                              //     freePro();
                              //   },
                              // ),
                              SizedBox(height:30),
                              // Text(debugString),
                            ]
                          )
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
          Text("Meters Left: ${Scan.meters}m", style: basicMediumDarkBlue,),
          Text("Grams Left: ${Scan.grams}g", style: basicMediumDarkBlue,),
          Text("Predicted Diameter: ${Scan.diameter}mm", style: basicSmallBlack,),
          Text("Predicted Circumference: ${Scan.diameter*3.14}mm", style: basicSmallBlack,),
          progressBar(context, Scan.grams),
          SizedBox(height: 15,),
          InkWell(
            onTap: (){
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
                  Text("Buy More", style: basicWhite,),
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








































