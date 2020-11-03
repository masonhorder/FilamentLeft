import 'package:CodingLog/api/sides_api.dart';
import 'package:CodingLog/notifier/sides_notifier.dart';
import 'package:CodingLog/api/log_api.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:CodingLog/style/headers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CodingLog/notifier/dataSettings_notifier.dart';
import 'package:CodingLog/api/dataSettings_api.dart';
import 'package:CodingLog/screens/home_page_panels.dart';
import 'package:CodingLog/style/global.dart';

// import 'package:CodingLog/functions/functions.dart';
// import 'package:CodingLog/model/stats.dart';






class Data extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Data> {
  @override
  void initState() {

    LogNotifier logNotifier = Provider.of<LogNotifier>(context, listen: false);
    getLogs(logNotifier);

    SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context, listen: false);
    getSides(sidesNotifier);

    MainDataSettingsNotifier mainDataSettingsNotifier = Provider.of<MainDataSettingsNotifier>(context, listen: false);
    getMainDataSettings(mainDataSettingsNotifier);


    

    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    LogNotifier logNotifier = Provider.of<LogNotifier>(context);
    SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context);
    MainDataSettingsNotifier mainDataSettingsNotifier = Provider.of<MainDataSettingsNotifier>(context);

    Future<void> _refreshList() async {
      getLogs(logNotifier);
      getSides(sidesNotifier);
      getMainDataSettings(mainDataSettingsNotifier);
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              pageHeaderCreator("Dice Coding Log"),

              RefreshIndicator(

                child: Column(
                  children: [


                    Container(
                      margin: EdgeInsets.only(top:40),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: EdgeInsets.only(left:18, right:18),

                        child: Column(
                          children:[
                            widgetHeaderCreator("Stats"),
                            mainDataPanel(context, mainDataSettingsNotifier, logNotifier),
                          ]
                        ),
                        padding: EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                          color: lightGreyColor,
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),  
                        ),
                      ),
                    ),



                    Container(
                      margin: EdgeInsets.only(top:40),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: EdgeInsets.only(left:18, right:18),
                        // height: 250,
                        child: Column(
                          children:[
                            widgetHeaderCreator("Charts"),
                            Container(
                              height: 335,
                              child: chartsSwiper(logNotifier),
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                          color: lightGreyColor,
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),  
                        ),
                      ),
                    ),


                    
                    
                    
                  ],
                ),
                onRefresh: _refreshList,
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}



