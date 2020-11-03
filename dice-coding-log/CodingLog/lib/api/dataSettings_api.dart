import 'package:CodingLog/model/dataSettings.dart';
import 'package:CodingLog/notifier/dataSettings_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';




getMainDataSettings(MainDataSettingsNotifier mainDataSettingsNotifier) async {
  await Firebase.initializeApp();
  QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection('mainDataSettings')
    .get();

  List<MainDataSettings> _mainDataSettingsList = [];

  snapshot.docs.forEach((document) {
    MainDataSettings mainDataSettings = MainDataSettings.fromMap(document.data());
    _mainDataSettingsList.add(mainDataSettings);
  });

  mainDataSettingsNotifier.mainDataSettingsList = _mainDataSettingsList;
  print('getting data - 1');
}



