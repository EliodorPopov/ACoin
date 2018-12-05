import 'package:acoin/dashboard.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Eliodor',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new Dashboard(title: 'Dashboard'),
    );
  }
}
