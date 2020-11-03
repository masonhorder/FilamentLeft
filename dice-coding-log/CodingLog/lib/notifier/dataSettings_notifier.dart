import 'dart:collection';
import 'package:CodingLog/model/dataSettings.dart';
import 'package:flutter/cupertino.dart';

class MainDataSettingsNotifier with ChangeNotifier {
  List<MainDataSettings> _mainDataSettingsList = [];


  UnmodifiableListView<MainDataSettings> get mainDataSettingsList => UnmodifiableListView(_mainDataSettingsList);

  set mainDataSettingsList(List<MainDataSettings> mainDataSettingsList) {
    _mainDataSettingsList = mainDataSettingsList;
    notifyListeners();
  }


}