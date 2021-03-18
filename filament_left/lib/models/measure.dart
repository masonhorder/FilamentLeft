import 'package:filament_left/db/database_provider.dart';

class Measure {
  int id;
  int circumference;



  Measure({this.id, this.circumference,});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProviderMeasure.COLUMN_CIRCUMFERENCE: circumference,
    };

    if (id != null) {
      map[DatabaseProviderMeasure.COLUMN_ID] = id;
      map[DatabaseProviderMeasure.COLUMN_CIRCUMFERENCE] = circumference;

    }

    return map;
  }

  Measure.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProviderMeasure.COLUMN_ID];
    circumference = map[DatabaseProviderMeasure.COLUMN_CIRCUMFERENCE];
  }
}