import 'package:filament_left/db/database_provider.dart';

class Spool {
  int id;
  int profileId;
  String color;
  int index;


  Spool({this.id, this.profileId, this.color});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProviderSpool.COLUMN_PROFILE_ID: profileId,
      DatabaseProviderSpool.COLUMN_COLOR: color,
      DatabaseProviderSpool.COLUMN_INDEX: index,
      
    };

    if (id != null) {
      map[DatabaseProviderSpool.COLUMN_ID] = id;
      map[DatabaseProviderSpool.COLUMN_PROFILE_ID] = profileId;
      map[DatabaseProviderSpool.COLUMN_COLOR] = color;
      map[DatabaseProviderSpool.COLUMN_INDEX] =  index;
      
    }

    return map;
  }

  Spool.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProviderSpool.COLUMN_ID];
    profileId = map[DatabaseProviderSpool.COLUMN_PROFILE_ID];
    color = map[DatabaseProviderSpool.COLUMN_COLOR];
    index = map[DatabaseProviderSpool.COLUMN_INDEX];
    
  }
}