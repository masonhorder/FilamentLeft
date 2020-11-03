import 'package:CodingLog/api/log_api.dart';
import 'package:CodingLog/model/log.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:CodingLog/notifier/sides_notifier.dart';
import 'package:CodingLog/style/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CodingLog/functions/functions.dart';
// import 'log_form.dart';

class LogDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LogNotifier logNotifier = Provider.of<LogNotifier>(context);

    _onLogDeleted(Log log) {
      Navigator.pop(context);
      Navigator.pop(context);
      logNotifier.deleteLog(log);

    }

    SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context);



    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("CANCEL", style: greyPopUpButton),
        onPressed:  () {Navigator.pop(context);},
      );
      Widget continueButton = FlatButton(
        child: Text("DELETE", style: redPopUpButton,),
        onPressed:  () {
          deleteLog(logNotifier.currentLog, _onLogDeleted); 
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        backgroundColor: lightGreyColor,
        title: Text("Delete Log Entry", style: popUpTitle,),
        content: Text("Are you sure you want to delete this log?", style: popUpDescription,),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }




    return Scaffold(
      appBar: AppBar(
        title: Text('Log Entry'),
        backgroundColor: darkGreyColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text('Date: ' + dateOfEntry(logNotifier.currentLog.startTime), style: entryDataList,),
                  margin: EdgeInsets.only(top: 24),
                ),
                Container(
                  child: Text('Time: ' + timeOfEntry(logNotifier.currentLog.startTime), style: entryDataList,),
                  margin: EdgeInsets.only(top: 13),
                ),
                Container(
                  child: Text('Coding Time: ' + timeOnEntry(logNotifier.currentLog.timeSpent), style: entryDataList,),
                  margin: EdgeInsets.only(top: 13),
                ),
                Container(
                  child: Text('Language: ' + sideOfEntry(logNotifier.currentLog.side, sidesNotifier), style: entryDataList,),
                  margin: EdgeInsets.only(top: 13),
                ),
              ],
            ),
          ),
        ),
      ),





      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // FloatingActionButton(
          //   heroTag: 'button1',
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (BuildContext context) {
          //         return LogForm(
          //           isUpdating: true,
          //         );
          //       }),
          //     );
          //   },
          //   child: Icon(Icons.edit),
          //   foregroundColor: Colors.white,
          // ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => showAlertDialog(context),
            child: Icon(Icons.delete),
            backgroundColor: Color(0xFFff0d0d),
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}