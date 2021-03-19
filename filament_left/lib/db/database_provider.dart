import 'package:filament_left/bloc/optInBloc.dart';
import 'package:filament_left/bloc/profileBloc.dart';
import 'package:filament_left/events/optInEvent.dart';
import 'package:filament_left/events/profileEvent.dart';
import 'package:filament_left/models/optIn.dart';
import 'package:filament_left/models/profiles.dart';
import 'package:filament_left/bloc/measureBloc.dart';
import 'package:filament_left/events/measureEvent.dart';
import 'package:filament_left/models/measure.dart';
import 'package:filament_left/models/spool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProviderProfile {
  static const String TABLE_PROFILE= "profile";
  static const String COLUMN_ID = "id";

  static const String COLUMN_INNER = "inner";
  static const String COLUMN_WIDTH = "width";
  static const String COLUMN_FILAMENT_SIZE = "filamentSize";
  static const String COLUMN_FILAMENT_TYPE = "filamentType";
  static const String COLUMN_NAME = "name";

  DatabaseProviderProfile._();
  static final DatabaseProviderProfile db = DatabaseProviderProfile._();

  Database _databaseProfile;

  Future<Database> get databaseProfile async {

    if (_databaseProfile != null) {
      return _databaseProfile;
    }
    

    _databaseProfile = await createDatabase();
    return _databaseProfile;
  }




  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'profileDB.db'),
      version: 1,
      onCreate: (Database databaseProfile, int profile) async {
        print("Creating colorTheme table");

        await databaseProfile.execute(
          "CREATE TABLE $TABLE_PROFILE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_INNER INTEGER,"
          "$COLUMN_WIDTH INTEGER,"
          "$COLUMN_FILAMENT_SIZE DOUBLE,"
          "$COLUMN_FILAMENT_TYPE STRING,"
          "$COLUMN_NAME TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Profile>> getProfiles(BuildContext context) async {
    final db = await databaseProfile;

    var profile = await db
        .query(TABLE_PROFILE, columns: [COLUMN_ID, COLUMN_INNER, COLUMN_WIDTH, COLUMN_FILAMENT_TYPE, COLUMN_FILAMENT_SIZE, COLUMN_NAME]);

    List<Profile> profileList = [];

    profile.forEach((currentProfile) {
      Profile profile = Profile.fromMap(currentProfile);

      profileList.add(profile);
    });


    if(profileList.length == 0){
      List listOfPresets = [["Hatchbox", 62, 80, 1.75, "PLA"],];
      for(List preset in listOfPresets){
        Profile profile = Profile(
          inner: preset[2],
          width: preset[1],
          filamentSize: preset[3],
          filamentType: preset[4],
          name: preset[0],
        );

        DatabaseProviderProfile.db.insert(profile).then(
          (storeProfile) => BlocProvider.of<ProfileBloc>(context).add(
            AddProfile(storeProfile),
          ),
        );
      }
    }

    return profileList;
  }

  Future<Profile> insert(Profile profile) async {
    final db = await databaseProfile;
    profile.id = await db.insert(TABLE_PROFILE, profile.toMap());
    return profile;
  }

  Future<int> delete(int id) async {
    final db = await databaseProfile;

    return await db.delete(
      TABLE_PROFILE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Profile profile) async {
    final db = await databaseProfile;

    return await db.update(
      TABLE_PROFILE,
      profile.toMap(),
      where: "id = ?",
      whereArgs: [profile.id],
    );
  }
}













class DatabaseProviderMeasure {
  static const String TABLE_PROFILE= "measure";
  static const String COLUMN_ID = "id";

  static const String COLUMN_CIRCUMFERENCE = "circumference";

  DatabaseProviderMeasure._();
  static final DatabaseProviderMeasure db = DatabaseProviderMeasure._();

  Database _databaseMeasure;

  Future<Database> get databaseMeasure async {

    if (_databaseMeasure != null) {
      return _databaseMeasure;
    }
    

    _databaseMeasure = await createDatabase();
    return _databaseMeasure;
  }




  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'measureDB.db'),
      version: 1,
      onCreate: (Database databaseMeasure, int measure) async {
        print("Creating measure table");

        await databaseMeasure.execute(
          "CREATE TABLE $TABLE_PROFILE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_CIRCUMFERENCE INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Measure>> getMeasures(BuildContext context) async {
    print("getting measure");
    final db = await databaseMeasure;

    var measure = await db
        .query(TABLE_PROFILE, columns: [COLUMN_ID, COLUMN_CIRCUMFERENCE,]);

    List<Measure> measureList = [];
    print(measure);
    measure.forEach((currentMeasure) {
      Measure measure = Measure.fromMap(currentMeasure);

      measureList.add(measure);
    });


    if(measureList.length == 0){

      Measure measure = Measure(
        circumference: 0,
      );

      DatabaseProviderMeasure.db.insert(measure).then(
        (storeMeasure) => BlocProvider.of<MeasureBloc>(context).add(
          AddMeasure(storeMeasure),
        ),
      );
    }

    return measureList;
  }

  Future<Measure> insert(Measure measure) async {
    final db = await databaseMeasure;
    measure.id = await db.insert(TABLE_PROFILE, measure.toMap());
    return measure;
  }

  Future<int> delete(int id) async {
    final db = await databaseMeasure;

    return await db.delete(
      TABLE_PROFILE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Measure measure) async {
    final db = await databaseMeasure;

    return await db.update(
      TABLE_PROFILE,
      measure.toMap(),
      where: "id = ?",
      whereArgs: [measure.id],
    );
  }
}









class DatabaseProviderOptIn {
  static const String TABLE_PROFILE= "optIn";
  static const String COLUMN_ID = "id";

  static const String COLUMN_OPTIN = "optIn";

  DatabaseProviderOptIn._();
  static final DatabaseProviderOptIn db = DatabaseProviderOptIn._();

  Database _databaseOptIn;

  Future<Database> get databaseOptIn async {

    if (_databaseOptIn != null) {
      return _databaseOptIn;
    }
    

    _databaseOptIn = await createDatabase();
    return _databaseOptIn;
  }




  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'optInDB.db'),
      version: 1,
      onCreate: (Database databaseOptIn, int optIn) async {
        print("Creating optIn table");

        await databaseOptIn.execute(
          "CREATE TABLE $TABLE_PROFILE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_OPTIN INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<OptIn>> getOptIns(BuildContext context) async {
    print("getting optIn");
    final db = await databaseOptIn;

    var optIn = await db
        .query(TABLE_PROFILE, columns: [COLUMN_ID, COLUMN_OPTIN,]);

    List<OptIn> optInList = [];
    print(optIn);
    optIn.forEach((currentOptIn) {
      OptIn optIn = OptIn.fromMap(currentOptIn);

      optInList.add(optIn);
    });


    if(optInList.length == 0){

      OptIn optIn = OptIn(
        optIn: 0,
      );

      DatabaseProviderOptIn.db.insert(optIn).then(
        (storeOptIn) => BlocProvider.of<OptInBloc>(context).add(
          AddOptIn(storeOptIn),
        ),
      );
    }

    return optInList;
  }

  Future<OptIn> insert(OptIn optIn) async {
    final db = await databaseOptIn;
    optIn.id = await db.insert(TABLE_PROFILE, optIn.toMap());
    return optIn;
  }

  Future<int> delete(int id) async {
    final db = await databaseOptIn;

    return await db.delete(
      TABLE_PROFILE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(OptIn optIn) async {
    final db = await databaseOptIn;

    return await db.update(
      TABLE_PROFILE,
      optIn.toMap(),
      where: "id = ?",
      whereArgs: [optIn.id],
    );
  }
}

















class DatabaseProviderSpool {
  static const String TABLE_SPOOL= "spool";
  static const String COLUMN_ID = "id";

  static const String COLUMN_PROFILE_ID = "profileId";
  static const String COLUMN_COLOR = "color";
  static const String COLUMN_INDEX = "spoolIndex";

  DatabaseProviderSpool._();
  static final DatabaseProviderSpool db = DatabaseProviderSpool._();

  Database _databaseSpool;

  Future<Database> get databaseSpool async {

    if (_databaseSpool != null) {
      return _databaseSpool;
    }
    

    _databaseSpool = await createDatabase();
    return _databaseSpool;
  }




  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'spoolDB.db'),
      version: 1,
      onCreate: (Database databaseSpool, int profile) async {
        print("Creating colorTheme table");

        await databaseSpool.execute(
          "CREATE TABLE $TABLE_SPOOL ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_PROFILE_ID INTEGER,"
          "$COLUMN_COLOR TEXT,"
          "$COLUMN_INDEX INT"
          ")",
        );
      },
    );
  }

  Future<List<Spool>> getSpools(BuildContext context) async {
    final db = await databaseSpool;

    var spool = await db
        .query(TABLE_SPOOL, columns: [COLUMN_ID, COLUMN_PROFILE_ID, COLUMN_COLOR, COLUMN_INDEX,]);

    List<Spool> spoolList = [];

    spool.forEach((currentSpool) {
      Spool spool = Spool.fromMap(currentSpool);

      spoolList.add(spool);
    });


    // if(profileList.length == 0){
    //   List listOfPresets = [["Hatchbox", 62, 80, 1.75, "PLA"],];
    //   for(List preset in listOfPresets){
    //     Spool profile = Spool(
    //       inner: preset[2],
    //       width: preset[1],
    //       filamentSize: preset[3],
    //     );

    //     DatabaseProviderProfile.db.insert(profile).then(
    //       (storeProfile) => BlocProvider.of<ProfileBloc>(context).add(
    //         AddProfile(storeProfile),
    //       ),
    //     );
    //   }
    // }

    return spoolList;
  }

  Future<Spool> insert(Spool spool) async {
    final db = await databaseSpool;
    spool.id = await db.insert(TABLE_SPOOL, spool.toMap());
    return spool;
  }

  Future<int> delete(int id) async {
    final db = await databaseSpool;

    return await db.delete(
      TABLE_SPOOL,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Spool spool) async {
    final db = await databaseSpool;

    return await db.update(
      TABLE_SPOOL,
      spool.toMap(),
      where: "id = ?",
      whereArgs: [spool.id],
    );
  }
}
