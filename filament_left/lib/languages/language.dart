import 'package:filament_left/languages/english.dart';
import 'package:filament_left/languages/french.dart';
import 'package:filament_left/languages/german.dart';
import 'package:filament_left/languages/spanish.dart';
import 'package:filament_left/models/sharedPrefs.dart';

Map langMap() {
  String language = SharedPrefs.prefs.getString("language");
  if(language == null){
    // SharedPrefs.prefs.setString("language", "English");
  }
  if(language == "English"){
    return englishMap();
  }
  else if(language == "Spanish"){
    return spanishMap();
  }
  else if(language == "French"){
    return frenchMap();
  }
  else if(language == "German"){
    return germanMap();
  }
  else{
    return englishMap();
  }
}