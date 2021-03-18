import 'package:flutter/material.dart';
import 'package:filament_left/style/globals.dart';

var textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  hintStyle: basicLightGrey,
  
  contentPadding: EdgeInsets.all(15.0),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: darkBlue, width: 2.3),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: darkBlue, width: 2.3),
  ),
);