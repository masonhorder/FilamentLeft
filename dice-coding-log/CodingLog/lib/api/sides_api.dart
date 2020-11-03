import 'package:CodingLog/model/sides.dart';
import 'package:CodingLog/notifier/sides_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';




getSides(SidesNotifier sidesNotifier) async {
  await Firebase.initializeApp();

  QuerySnapshot snapshot = await FirebaseFirestore.instance
    .collection('sidesSettings')
    .orderBy('side')
    .get();

  List<Sides> _sidesList = [];

  snapshot.docs.forEach((document) {
    Sides sides = Sides.fromMap(document.data());
    _sidesList.add(sides);
  });

  sidesNotifier.sidesList = _sidesList;
  print('getting data - 3');
}



