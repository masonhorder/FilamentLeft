import 'package:filament_left/db/database_provider.dart';

class Profile {
  int id;
  int inner;
  int width;
  double filamentSize;
  String filamentType;
  String name;
  int spoolWeight;


  Profile({this.id, this.inner, this.width, this.filamentSize, this.filamentType, this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProviderProfile.COLUMN_INNER: inner,
      DatabaseProviderProfile.COLUMN_WIDTH: width,
      DatabaseProviderProfile.COLUMN_FILAMENT_SIZE: filamentSize,
      DatabaseProviderProfile.COLUMN_FILAMENT_TYPE: filamentType,
      DatabaseProviderProfile.COLUMN_NAME: name,
      // DatabaseProviderProfile.COLUMN_SPOOL_WEIGHT: spoolWeight,
    };

    if (id != null) {
      map[DatabaseProviderProfile.COLUMN_ID] = id;
      map[DatabaseProviderProfile.COLUMN_INNER] = inner;
      map[DatabaseProviderProfile.COLUMN_WIDTH] = width;
      map[DatabaseProviderProfile.COLUMN_FILAMENT_SIZE] =  filamentSize;
      map[DatabaseProviderProfile.COLUMN_FILAMENT_TYPE] =  filamentType;
      map[DatabaseProviderProfile.COLUMN_NAME] =  name;
      // map[DatabaseProviderProfile.COLUMN_SPOOL_WEIGHT] =  spoolWeight;
    }

    return map;
  }

  Profile.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProviderProfile.COLUMN_ID];
    inner = map[DatabaseProviderProfile.COLUMN_INNER];
    width = map[DatabaseProviderProfile.COLUMN_WIDTH];
    filamentSize = map[DatabaseProviderProfile.COLUMN_FILAMENT_SIZE];
    filamentType = map[DatabaseProviderProfile.COLUMN_FILAMENT_TYPE];
    name = map[DatabaseProviderProfile.COLUMN_NAME];
  }
}