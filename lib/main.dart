import 'package:firstflut/dashboard.dart';
import 'package:flutter/material.dart';

//import 'buildExpensesPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Eliodor',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
        //fontFamily: 'Pacifico',
      ),
      home: new Dashboard(title: 'Dashboard'),
    );
  }
}
