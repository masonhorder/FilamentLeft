import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:CodingLog/notifier/sides_notifier.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:CodingLog/style/global.dart';






























weeklyChartEpoch(){
  List returnList = [0];
  DateTime today = DateTime.now(); 
  int i = 0;
  while(i<13){
    DateTime dayLow = today.subtract(new Duration(days: (today.weekday-(i*7)-1) ));
    int lowEpoch = (DateTime.parse(formatDate(dayLow, [yyyy, "-", mm, "-", dd]) +  " 00:00:01").millisecondsSinceEpoch.toInt());
    lowEpoch = (lowEpoch/1000).round();
    returnList.add(lowEpoch);
    
    DateTime dayHigh = today.subtract(new Duration(days: (today.weekday-((i*7)+6)-1) ));
    int highEpoch = (DateTime.parse(formatDate(dayHigh, [yyyy, "-", mm, "-", dd]) +  " 23:59:59").millisecondsSinceEpoch.toInt());
    highEpoch = (highEpoch/1000).round();
    returnList.add(highEpoch);
    i++;
  }
  // print(returnList);
  return returnList;
}































convertStringToDate(int strDate){
  DateTime date = DateTime.fromMillisecondsSinceEpoch(strDate*1000);

  return date;
}

formatListTitle(int startTime, int timeSpent, int style){

  double dblMinutes = timeSpent/1000/60;
  int minutes = dblMinutes.round();
  DateTime date = convertStringToDate(startTime);
  String timeIdentifier;
  int timeInt = minutes;

  if(minutes > 53){
    double dblHours = minutes/60;
    int hours = dblHours.round();
    timeInt = hours;
    if(hours != 1){
      timeIdentifier = "Hours";
    } else{
      timeIdentifier = "Hour";
    }
  }else{
    if(minutes != 1){
      timeIdentifier = "Minutes";
    } else{
      timeIdentifier = "Minute";
    }
  }
  if(style == 1){
    return Text(timeInt.toString() + " " +  timeIdentifier  + " " +  formatDate(date, [hh, ':', nn, ' ', am, ', ', M, ' ', dd]), style: titleOfEntry,);
  }else if(style == 2){
    return Text(timeInt.toString() +  " " +  timeIdentifier  + " " + formatDate(date, [hh, ':', nn, am, ', ', M, ' ', dd]), style: titleOfEntry,);
  }
}


formatListSubTitle(int side, SidesNotifier sidesNotifier){
  String sideName = sidesNotifier.sidesList[side-2].language;
  return Text(sideName, style: subTitleOfEntry,);
}







dateOfEntry(int startTime){
  DateTime date = convertStringToDate(startTime);
  return formatDate(date, [MM, " ", d, ", ", yyyy]);
}

timeOfEntry(int startTime){
  DateTime date = convertStringToDate(startTime);
  return formatDate(date, [hh, ":", nn, " ", am]);
}

timeOnEntry(int timeSpent){
  String hourString;
  int hours = 0;
  double timeSpentDbl = timeSpent/1000/60;
  timeSpent = timeSpentDbl.round();
  if(timeSpent > 60){
    hours = (timeSpent/60).floor();
  } else{
    hours = 0;
  }
  int minutes = timeSpent - (hours * 60);
  if(hours != 0){
    if(hours == 0){hourString = "hour";}else{hourString = "hours";}
    if(minutes == 0){
      return hours.toString() + " "+  hourString;
    }else{
      return hours.toString() + " "+  hourString + ", " + minutes.toString() + " minutes";
    }
  } else{
    return minutes.toString() + " minutes";
  }
}



sideOfEntry(int side, SidesNotifier sidesNotifier){
  String sideName = sidesNotifier.sidesList[side-2].language;
  return sideName;
}

















// ###############
// #### STATS ####
// ###############




statAllTime(LogNotifier logNotifier) {
  int statTotal = 0;
  int numberOfLogs = logNotifier.logList.length;
  for(int index = 0; index < numberOfLogs; index++){
    statTotal += logNotifier.logList[index].timeSpent;
  }
  return statTotal;
}




// time this week
statTimeThisWeek(LogNotifier logNotifier) {
  int statTotal = 0;
  int numberOfLogs = logNotifier.logList.length;
  int thisWeekEpochInt = ((DateTime.parse(formatDate(DateTime.now().subtract(new Duration(days: DateTime.now().weekday-1)), [yyyy, "-", mm, "-", dd]) +  " 00:00:01").millisecondsSinceEpoch.toInt())/1000).round();


  for(int index = 0; index < numberOfLogs; index++){
    if(logNotifier.logList[index].startTime >= thisWeekEpochInt ){
      statTotal += logNotifier.logList[index].timeSpent;
    }
  }
  return statTotal;
}


// time today
statTimeToday(LogNotifier logNotifier){
  int statTotal = 0;
  int numberOfLogs = logNotifier.logList.length;
  int todayEpochInt = ((DateTime.parse(formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd]) +  " 00:00:01").millisecondsSinceEpoch.toInt())/1000).round();


  for(int index = 0; index < numberOfLogs; index++){
    if(logNotifier.logList[index].startTime >= todayEpochInt ){
      statTotal += logNotifier.logList[index].timeSpent;
    }
    
  }
  return statTotal;
}




// average time per month
statAverageMonth(LogNotifier logNotifier){
  int statTotal = 0;
  int numberOfLogs = logNotifier.logList.length;
  int thisMonthEpochInt = ((DateTime.parse(formatDate(DateTime.now().subtract(new Duration(days: 30)), [yyyy, "-", mm, "-", dd]) +  " 00:00:01").millisecondsSinceEpoch.toInt())/1000).round();


  for(int index = 0; index < numberOfLogs; index++){
    if(logNotifier.logList[index].startTime >= thisMonthEpochInt ){
      statTotal += logNotifier.logList[index].timeSpent;
    }
  }
  return (statTotal/30).round();
}


// average time all time
statAverageAllTime(LogNotifier logNotifier){
  int statTotal = 0;
  int numberOfLogs = logNotifier.logList.length;
  int leastEpoch = logNotifier.logList[0].startTime;


  for(int index = 0; index < numberOfLogs; index++){
    if(leastEpoch > logNotifier.logList[index].startTime){
      leastEpoch = logNotifier.logList[index].startTime;
    }
  }

  int daysSince = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(leastEpoch*1000)).inDays;

  for(int index = 0; index < numberOfLogs; index++){
    statTotal += logNotifier.logList[index].timeSpent;
  }
  return (statTotal/daysSince).round();
}


// weekly chart


statWeeklyChart(LogNotifier logNotifier){
  DateTime today = DateTime.now(); 
  int i = 0;
  int numberOfLogs = logNotifier.logList.length;
  List returnList = [0];
  int runningTotal;

  while(i<13){
    DateTime dayLow = today.subtract(new Duration(days: (today.weekday-(i*7)-1) ));
    int lowEpoch = (DateTime.parse(formatDate(dayLow, [yyyy, "-", mm, "-", dd]) +  " 00:00:01").millisecondsSinceEpoch.toInt());
    lowEpoch = (lowEpoch/1000).round();
    DateTime dayHigh = today.subtract(new Duration(days: (today.weekday-((i*7)+6)-1) ));
    int highEpoch = (DateTime.parse(formatDate(dayHigh, [yyyy, "-", mm, "-", dd]) +  " 23:59:59").millisecondsSinceEpoch.toInt());
    highEpoch = (highEpoch/1000).round();

    runningTotal = 0;

    for(int index = 0; index < numberOfLogs; index++){
      if(logNotifier.logList[index].startTime >= lowEpoch && logNotifier.logList[index].startTime <= highEpoch){
        runningTotal += logNotifier.logList[index].timeSpent;
      }
    }

    returnList.add(runningTotal);

    i++;
  }


  return returnList;
}








// daily chart

statDailyChartData(LogNotifier logNotifier){
  DateTime today = DateTime.now(); 
  int i = 0;
  while(i<7){
    DateTime day = today.subtract(new Duration(days: (today.weekday-i-1) ));
    int lowEpoch = (DateTime.parse(formatDate(day, [yyyy, "-", mm, "-", dd]) +  " 00:00:01").millisecondsSinceEpoch.toInt());
    lowEpoch = (lowEpoch/1000).round();
    int highEpoch = (DateTime.parse(formatDate(day, [yyyy, "-", mm, "-", dd]) +  " 23:59:59").millisecondsSinceEpoch.toInt());
    highEpoch = (highEpoch/1000).round();




    i++;
  }
  return [1,2,3,45,6,7,8];
}
