import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as Path;  
import 'package:firebase_storage/firebase_storage.dart';




filamentLeft(int outerDiameter, int innerDiameter, int width, double filament, bool circumference){
  if(circumference){
    outerDiameter = (outerDiameter/3.14).round();
  }
  return (pow(outerDiameter,2)-pow(innerDiameter,2))*3.1415*width*0.8/4/pow(filament,2)/1000;
}

metersToGrams(num meters, String filamentType, bool filament){
  if(!filament){
    switch(filamentType){
      case "PLA": {
        return meters/.3353;
      }
      case "ABS": {
        return meters/.3998;
      }
      case "ASA": {
        return meters/.3886;
      }
      case "PETG": {
        return meters/.3274;
      }
      case "Nylon": {
        return meters/.385;
      }
      case "PC": {
        return meters/.3465;
      }
      case "HIPS": {
        return meters/.3886;
      }
      case "PVA": {
        return meters/.3494;
      }
      case "TPU": {
        return meters/.3465;
      }
      case "PMMA": {
        return meters/.3523;
      }
      case "Copper Fill": {
        return meters/.1066;
      }
      

      break;
    }
  }
  else{
    switch(filamentType){
      case "PLA": {
        return meters/.1264;
      }
      case "ABS": {
        return meters/.1507;
      }
      case "ASA": {
        return meters/.1465;
      }
      case "PETG": {
        return meters/.1234;
      }
      case "Nylon": {
        return meters/.1451;
      }
      case "PC": {
        return meters/.1306;
      }
      case "HIPS": {
        return meters/.1465;
      }
      case "PVA": {
        return meters/.1317;
      }
      case "TPU": {
        return meters/.1306;
      }
      case "PMMA": {
        return meters/.1328;
      }
      case "Copper Fill": {
        return meters/.04202;
      }
      

      break;
    }
  }

}




Future<String> uploadFile(File _image) async {
  
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('images/${DateTime.now().microsecondsSinceEpoch}.png');
  UploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask;
  print('File Uploaded');
  String returnURL;
  await storageReference.getDownloadURL().then((fileURL) {
    returnURL =  fileURL;
  });
  return returnURL;
}