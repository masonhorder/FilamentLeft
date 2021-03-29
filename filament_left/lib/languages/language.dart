import 'package:filament_left/languages/english.dart';

class Language{static String language;}

String returnLanugageMap(String language){
  if(language == "english"){
    return englishMap();
  }
}