import 'package:flutter/material.dart';

class ActiveProfile{
  static bool isEditing = false; 
  static var profile;
  static int index;
}

class EditForm{
  static String name;
  static int inner;
  static int width;
  static bool filament = false;
  static String value = "";
  static String filamentType;
  static bool circumference = false;
  static bool presetProfile = false;

  static final nameController = TextEditingController();
  static final innerController = TextEditingController();
  static final widthController = TextEditingController();
}