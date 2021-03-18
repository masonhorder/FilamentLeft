import 'package:filament_left/db/database_provider.dart';

class OptIn {
  int id;
  int optIn;



  OptIn({this.id, this.optIn,});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProviderOptIn.COLUMN_OPTIN: optIn,
    };

    if (id != null) {
      map[DatabaseProviderOptIn.COLUMN_ID] = id;
      map[DatabaseProviderOptIn.COLUMN_OPTIN] = optIn;

    }

    return map;
  }

  OptIn.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProviderOptIn.COLUMN_ID];
    optIn = map[DatabaseProviderOptIn.COLUMN_OPTIN];
  }
}