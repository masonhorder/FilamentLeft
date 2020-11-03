import 'package:CodingLog/functions/functions.dart';
import 'package:CodingLog/notifier/dataSettings_notifier.dart';
import 'package:CodingLog/style/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:CodingLog/style/headers.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:CodingLog/api/dataSettings_api.dart';
import 'package:provider/provider.dart';



// import 'package:DiceCodingLog/api/stats_api.dart';
// import 'package:DiceCodingLog/notifier/sides_notifier.dart';
// import 'package:DiceCodingLog/api/log_api.dart';
// import 'package:DiceCodingLog/notifier/log_notifier.dart';
// import 'package:DiceCodingLog/style/pageHeader.dart';
// import 'package:provider/provider.dart';
// import 'package:DiceCodingLog/api/dataSettings_api.dart';
// import 'package:DiceCodingLog/model/stats.dart';
// import 'package:DiceCodingLog/functions/functions.dart';





mainDataPanel(BuildContext context, MainDataSettingsNotifier mainDataSettingsNotifier, LogNotifier logNotifier){
  getMainDataSettings(mainDataSettingsNotifier);
  return Container(
    child: ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {

        if(mainDataSettingsNotifier.mainDataSettingsList[index].id == 1){
          return Text("All Time: " + timeOnEntry(statAllTime(logNotifier)), style: darkTitleOfEntry,);
        }
        if(mainDataSettingsNotifier.mainDataSettingsList[index].id == 2){
          return Text("Time This Week: " + timeOnEntry(statTimeThisWeek(logNotifier)), style: darkTitleOfEntry,);
        }
        if(mainDataSettingsNotifier.mainDataSettingsList[index].id == 3){
          return Text("Time Today: " + timeOnEntry(statTimeToday(logNotifier)), style: darkTitleOfEntry,);
        }
        if(mainDataSettingsNotifier.mainDataSettingsList[index].id == 4){
          return(Text("Average Per Day(All Time): " + timeOnEntry(statAverageAllTime(logNotifier)), style: darkTitleOfEntry,));
        }
        if(mainDataSettingsNotifier.mainDataSettingsList[index].id == 5){
          return(Text("Average Per Day(This Month): " + timeOnEntry(statAverageMonth(logNotifier)), style: darkTitleOfEntry,));
        }

        return Text("There was a problem prossesing your data", style: darkTitleOfEntry,);

      },
      itemCount: mainDataSettingsNotifier.mainDataSettingsList.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
    ),
  );  
  // return Container(child:Text('error'));           
}





chartsSwiper(LogNotifier logNotifier){


  return Swiper(
    itemCount: 2,
    itemBuilder: (BuildContext context, int index){

      if(index == 0){
        return Column(
          children:[
            Container(
              margin: EdgeInsets.only(top:10, bottom: 10),
              child: chartTitleHeaderCreator("Minutes Per Day This Week"),
            ),
            Container(
              height: 210,
              child: dailyChart(logNotifier),
              margin: EdgeInsets.only(bottom: 40),
            )
          ]
        );
      }
      else if(index == 1){
        return Column(
          children:[
            Container(
              margin: EdgeInsets.only(top:10, bottom: 10),
              child: chartTitleHeaderCreator("Hours Per Week for 13 Weeks"),
            ),
            Container(
              height: 210,
              child: weeklyChart(),
              margin: EdgeInsets.only(bottom: 40),
            )
          ]
        );
      }
      else if(index == 2){
        return Column(
          children:[
            Container(
              margin: EdgeInsets.only(top:10, bottom: 10),
              child: chartTitleHeaderCreator("Rolling 28 Day Average for 2 months"),
            ),
            Container(
              height: 210,
              // child: ,
              margin: EdgeInsets.only(bottom: 40),
            )
          ]
        );
      }
      else{
        return Center(child: Text('Something Went Wrong, Please Try Again Later', style: darkTitleOfEntry,));
      }

    },
    // autoplay: true,
    pagination: new SwiperPagination(
      builder: new DotSwiperPaginationBuilder(
          activeColor: hotPinkColor,
      )
    ),
    loop: false,
    duration:100,
  );
}





























dailyChart(LogNotifier logNotifier){
  // if(DailyChartDataResults.monday == 0 && DailyChartDataResults.tuesday == 0 && DailyChartDataResults.wednesday == 0 && DailyChartDataResults.thursday == 0 && DailyChartDataResults.friday == 0 && DailyChartDataResults.saturday == 0 && DailyChartDataResults.sunday == 0){
  //   return Center(child: Text("No Coding For This Week Yet", style: darkTitleOfEntry,));
  // }
  // else{
    return DailyDataChart(_createSampleData(logNotifier), animate: false,);
  // }  
}
class DailyDataChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DailyDataChart(this.seriesList, {this.animate});

  factory DailyDataChart.withSampleData(logNotifier) {
    return new DailyDataChart(
      _createSampleData(logNotifier),
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}

/// Sample ordinal data type.
class DailyChartData {
  final String year;
  final int minutes;

  DailyChartData(this.year, this.minutes);
}



List<charts.Series<DailyChartData, String>> _createSampleData(LogNotifier logNotifier) {
  var dailyChartData = statDailyChartData(logNotifier);
  final data = [
    new DailyChartData('Mon', dailyChartData[0]),
    new DailyChartData('Tue', dailyChartData[1]),
    new DailyChartData('Wed', dailyChartData[2]),
    new DailyChartData('Thu', dailyChartData[3]),
    new DailyChartData('Fri', dailyChartData[4]),
    new DailyChartData('Sat', dailyChartData[5]),
    new DailyChartData('Sun', dailyChartData[6]),
  ];



  return [
    new charts.Series<DailyChartData, String>(
      id: 'dailyData',
      colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
      domainFn: (DailyChartData dailyData, _) => dailyData.year,
      measureFn: (DailyChartData dailyData, _) => dailyData.minutes,
      data: data,
    )
  ];
}




































weeklyChart(){
  return WeeklyDataChart(_createWeeklyData(), animate: false,);  
}
class WeeklyDataChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  WeeklyDataChart(this.seriesList, {this.animate});

  factory WeeklyDataChart.withSampleData() {
    return new WeeklyDataChart(
      _createWeeklyData(),
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

/// Sample ordinal data type.
class WeeklyChartData {
  final DateTime date;
  final int minutes;

  WeeklyChartData(this.date, this.minutes);
}


  List epochList = weeklyChartEpoch();

List<charts.Series<WeeklyChartData, DateTime>> _createWeeklyData() {
  
  final data = [
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[25]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[23]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[21]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[19]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[17]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[15]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[13]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[11]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[9]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[7]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[5]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[3]*1000), ((1)/60).round()),
    new WeeklyChartData(DateTime.fromMillisecondsSinceEpoch(epochList[1]*1000), ((1)/60).round()),    
  ];



  return [
    charts.Series<WeeklyChartData, DateTime>(
      id: 'weekData',
      colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
      domainFn: (WeeklyChartData weekData, _) => weekData.date,
      measureFn: (WeeklyChartData weekData, _) => weekData.minutes,
      data: data,
    )
  ];
}















