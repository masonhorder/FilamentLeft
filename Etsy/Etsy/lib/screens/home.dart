import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Etsy/style/headers.dart';
import 'package:Etsy/style/global.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // @override
  // void initState() {
  //   // LogNotifier logNotifier = Provider.of<LogNotifier>(context, listen: false);
  //   // getLogs(logNotifier);

  //   // SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context, listen: false);
  //   // getSides(sidesNotifier);

  //   // MainDataSettingsNotifier mainDataSettingsNotifier = Provider.of<MainDataSettingsNotifier>(context, listen: false);
  //   // getMainDataSettings(mainDataSettingsNotifier);


  //   super.initState();
  // }





  @override
  Widget build(BuildContext context) {
    // LogNotifier logNotifier = Provider.of<LogNotifier>(context);
    // SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context);
    // MainDataSettingsNotifier mainDataSettingsNotifier = Provider.of<MainDataSettingsNotifier>(context);


    // Future<void> _refreshList() async {
    //   // getLogs(logNotifier);
    //   // getSides(sidesNotifier);
    // }

    return Scaffold(
      body: Container(
        width:MediaQuery.of(context).size.width,
        child: Column(
          children: [
            pageHeaderCreator("Etsy Data"),

            // Expanded(
            //   child: new RefreshIndicator(
            //     child: ListView.separated(
            //       // scrollDirection: Axis.vertical,
            //       // shrinkWrap: true,
            //       itemBuilder: (BuildContext context, int index) {
            //         return ListTile(
            //           title: formatListTitle(logNotifier.logList[index].startTime, logNotifier.logList[index].timeSpent, 1),
            //           subtitle: formatListSubTitle(logNotifier.logList[index].side, sidesNotifier),
            //           onTap: () {
            //             logNotifier.currentLog = logNotifier.logList[index];
            //             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            //               return LogDetail();
            //             }));
            //           },
            //         );
            //       },
            //       itemCount: logNotifier.logList.length,
            //       separatorBuilder: (BuildContext context, int index) {
            //         return Divider(
            //           color: Colors.grey,
            //         );
            //       },
            //     ),
            //     onRefresh: _refreshList,
            //   ),
            // ),
          ],
        ),
      ),

  
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     logNotifier.currentLog = null;
      //     Navigator.of(context).push(
      //       MaterialPageRoute(builder: (BuildContext context) {
      //         return LogForm(
      //           isUpdating: false,
      //         );
      //       }),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   foregroundColor: Colors.white,
      // ),
    );
  }
}