import 'dart:io';
import 'package:CodingLog/api/log_api.dart';
import 'package:CodingLog/model/log.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CodingLog/style/global.dart';
import 'package:CodingLog/api/sides_api.dart';
import 'package:CodingLog/notifier/sides_notifier.dart';


class LogForm extends StatefulWidget {
  final bool isUpdating;

  LogForm({@required this.isUpdating});

  @override
  _LogFormState createState() => _LogFormState();
}

class _LogFormState extends State<LogForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List _subingredients = [];
  Log _currentLog;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    LogNotifier logNotifier = Provider.of<LogNotifier>(context, listen: false);

    if (logNotifier.currentLog != null) {
      _currentLog = logNotifier.currentLog;
    } else {
      _currentLog = Log();
    }

    SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context, listen: false);
    getSides(sidesNotifier);

  }

  

  Widget _buildLanguageField(SidesNotifier sidesNotifier) {
    String _value;
    return DropdownButton(
      value: _value,
      items: [
        
        DropdownMenuItem(
          child: Text(sidesNotifier.sidesList[0].language),
          value: 1,
        ),
      ],
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      }
    );
  }






  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      // initialValue: _currentLog.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        // if (value.isEmpty) {
        //   return 'Category is required';
        // }

        // if (value.length < 3 || value.length > 20) {
        //   return 'Category must be more than 3 and less than 20';
        // }

        return null;
      },
      onSaved: (String value) {
        // _currentLog.timeSpent = value;
        _currentLog.timeSpent = 18000000;

      },
    );
  }


  _onLogUploaded(Log log) {
    LogNotifier logNotifier = Provider.of<LogNotifier>(context, listen: false);
    logNotifier.addLog(log);
    Navigator.pop(context);
  }



  _saveLog() {
    print('saveLog Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');


    uploadLogAndImage(_currentLog, widget.isUpdating, _imageFile, _onLogUploaded);
  }










  @override
  Widget build(BuildContext context) {
    SidesNotifier sidesNotifier = Provider.of<SidesNotifier>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Log Entry'),
        backgroundColor: darkGreyColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          // autovalidate: true,
          child: Column(children: <Widget>[
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Log" : "Create Log",
              textAlign: TextAlign.center,
              style: smallPageHeader,
            ),
            _buildLanguageField(sidesNotifier),
            _buildCategoryField(),
            SizedBox(height: 16),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveLog();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

}
