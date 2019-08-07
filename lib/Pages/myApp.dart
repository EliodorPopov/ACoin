import 'package:acoin/Pages/dashboard.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ACoin',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new Dashboard(title: 'Dashboard'),
    );
  }
}
