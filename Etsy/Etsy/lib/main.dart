import 'package:Etsy/style/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Etsy/screens/orders.dart';
import 'package:Etsy/screens/money.dart';
import 'package:Etsy/screens/home.dart';


// void main() => runApp(MultiProvider(
//       providers: [
//         // ChangeNotifierProvider(
//         //   create: (context) => LogNotifier(),
//         // ),
//         // ChangeNotifierProvider(
//         //   create: (context) => SidesNotifier(),
//         // ),
//         // ChangeNotifierProvider(
//         //   create: (context) => MainDataSettingsNotifier(),
//         // ),
//       ],
//       child: MyApp(),
//     ));


void main() {
  runApp(MyApp());
}

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
        length: 3,
        child: new Scaffold(
          body: TabBarView(
            children: [
              Home(),
              Money(),
              Orders(),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.account_balance),
              ),
              Tab(
                icon: new Icon(Icons.monetization_on_rounded),
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