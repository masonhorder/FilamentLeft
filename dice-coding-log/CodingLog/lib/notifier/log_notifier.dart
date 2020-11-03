import 'dart:collection';

import 'package:CodingLog/model/log.dart';
import 'package:flutter/cupertino.dart';

class LogNotifier with ChangeNotifier {
  List<Log> _logList = [];
  Log _currentLog;

  UnmodifiableListView<Log> get logList => UnmodifiableListView(_logList);

  Log get currentLog => _currentLog;

  set logList(List<Log> logList) {
    _logList = logList;
    notifyListeners();
  }

  set currentLog(Log log) {
    _currentLog = log;
    notifyListeners();
  }

  addLog(Log log) {
    _logList.insert(0, log);
    notifyListeners();
  }

  deleteLog(Log log) {
    _logList.removeWhere((_log) => _log.id == log.id);
    notifyListeners();
  }
}