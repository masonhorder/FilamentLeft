import 'package:CodingLog/api/sides_api.dart';
import 'package:CodingLog/notifier/sides_notifier.dart';
import 'package:CodingLog/api/log_api.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:CodingLog/screens/detail.dart';
import 'package:CodingLog/screens/log_form.dart';
import 'package:CodingLog/style/headers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CodingLog/functions/functions.dart';
import 'package:CodingLog/api/dataSettings_api.dart';
import 'package:CodingLog/notifier/dataSettings_notifier.dart';


class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            pageHeaderCreator("Entry Stream"),
            Expanded(
              child: new RefreshIndicator(
                child: ListView.separated(
                  // scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: formatListTitle(logNotifier.logList[index].startTime, logNotifier.logList[index].timeSpent, 1),
                      subtitle: formatListSubTitle(logNotifier.logList[index].side, sidesNotifier),
                      onTap: () {
                        logNotifier.currentLog = logNotifier.logList[index];
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return LogDetail();
                        }));
                      },
                    );
                  },
                  itemCount: logNotifier.logList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                ),
                onRefresh: _refreshList,
              ),
            ),
          ],
        ),
      ),

  
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logNotifier.currentLog = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return LogForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}