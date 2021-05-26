import 'package:filament_left/style/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: darkBlue,
      child: Center(
        child: SpinKitChasingDots(
          color: darkBlue,
          size: 80.0,
        ),
      ),
    );
  }
}