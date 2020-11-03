import 'dart:io';
import 'package:CodingLog/model/log.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';











getLogs(LogNotifier logNotifier) async {
  await Firebase.initializeApp();
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('log')
      .orderBy('startTime', descending: true)
      .get();

  List<Log> _logList = [];

  snapshot.docs.forEach((document) {
    Log log = Log.fromMap(document.data());
    log.id =document.id;
    _logList.add(log);
    
  });

  logNotifier.logList = _logList;

  print('getting data - 2');
  
}



uploadLogAndImage(Log log, bool isUpdating, File localFile, Function logUploaded) async {
    await Firebase.initializeApp();

  _uploadLog(log, isUpdating, logUploaded);
}




_uploadLog(Log log, bool isUpdating, Function logUploaded) async {
  await Firebase.initializeApp();
  CollectionReference logRef = FirebaseFirestore.instance.collection('log');


  if (isUpdating) {

    await logRef.doc(log.id).update(log.toMap());

    logUploaded(log);
    print('updated log with id: ${log.id}');
  } else {

    DocumentReference documentRef = await logRef.add(log.toMap());

    log.id = documentRef.id;

    print('uploaded log successfully: ${log.toString()}');

    await documentRef.set(log.toMap());

    // , merge: true

    logUploaded(log);
  }
}

deleteLog(Log log, Function logDeleted) async {
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.collection('log').doc(log.id).delete();
  logDeleted(log);
}







































// login(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .signInWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       print("Log In: $firebaseUser");
//       authNotifier.setUser(firebaseUser);
//     }
//   }
// }

// signup(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     UserUpdateInfo updateInfo = UserUpdateInfo();
//     updateInfo.displayName = user.displayName;

//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       await firebaseUser.updateProfile(updateInfo);

//       await firebaseUser.reload();

//       print("Sign up: $firebaseUser");

//       FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//       authNotifier.setUser(currentUser);
//     }
//   }
// }

// signout(AuthNotifier authNotifier) async {
//   await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

//   authNotifier.setUser(null);
// }

// initializeCurrentUser(AuthNotifier authNotifier) async {
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

//   if (firebaseUser != null) {
//     print(firebaseUser);
//     authNotifier.setUser(firebaseUser);
//   }
// }