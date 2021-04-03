import 'package:filament_left/style/globals.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFloatingFlushbar(BuildContext context, String title, String message) {
  Flushbar(
    shouldIconPulse: false,
    margin:  EdgeInsets.only(left: 10, right: 10, bottom: 16),
    borderRadius: 8,
    backgroundColor: darkBlue,
    boxShadows: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    icon: Icon(Icons.copy_outlined, color: Colors.white,),

    dismissDirection: FlushbarDismissDirection.VERTICAL,
    // The default curve is Curves.easeOut
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: title,
    message: message,
    duration: Duration(seconds: 6),
  )..show(context);
  
}