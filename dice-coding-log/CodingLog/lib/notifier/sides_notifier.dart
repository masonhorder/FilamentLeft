import 'dart:collection';
import 'package:CodingLog/model/sides.dart';
import 'package:flutter/cupertino.dart';

class SidesNotifier with ChangeNotifier {
  List<Sides> _sidesList = [];
  Sides _currentSides;

  UnmodifiableListView<Sides> get sidesList => UnmodifiableListView(_sidesList);

  Sides get currentSides => _currentSides;

  set sidesList(List<Sides> sidesList) {
    _sidesList = sidesList;
    notifyListeners();
  }

  set currentSides(Sides sides) {
    _currentSides = sides;
    notifyListeners();
  }
}