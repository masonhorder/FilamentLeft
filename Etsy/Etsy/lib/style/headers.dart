import 'package:flutter/material.dart';
import 'package:Etsy/style/global.dart';

pageHeaderCreator(String pageHeaderTitle){
  return Container(margin: EdgeInsets.only(top: 80, bottom: 25), child: Text(pageHeaderTitle, style: pageHeader),);
}

widgetHeaderCreator(String widgetTitleString){
  return Container(
    alignment: Alignment.topLeft,
    margin: EdgeInsets.only(bottom: 10), 
    child: Text(widgetTitleString, style: widgetTitle),
  );
}

chartTitleHeaderCreator(String chartTitleString){
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(bottom: 10), 
    child: Text(chartTitleString, style: chartTitle, textAlign: TextAlign.center),
  );
}