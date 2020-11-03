import 'package:CodingLog/notifier/sides_notifier.dart';
import 'package:CodingLog/notifier/log_notifier.dart';
import 'package:CodingLog/style/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CodingLog/notifier/dataSettings_notifier.dart';
import 'package:CodingLog/screens/data.dart';
import 'package:CodingLog/screens/feed.dart';
import 'package:CodingLog/api/dataSettings_api.dart';


void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LogNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => SidesNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainDataSettingsNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Coding Log',
      
      theme: ThemeData(
        accentColor: hotPinkColor,
        scaffoldBackgroundColor: pageGreyColor,
      ),
      home: DefaultTabController(
        length: 2,
        child: new Scaffold(
          body: TabBarView(
            children: [
              Data(),
              Feed(),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.analytics),
              ),
              Tab(
                icon: new Icon(Icons.list),
              ),
            ],
            labelColor: hotPinkColor,
            unselectedLabelColor: hotPinkColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: hotPinkColor,
          ),
        ),
      ),      
    );
  }
}