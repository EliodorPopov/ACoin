<<<<<<< HEAD

import 'package:acoin/modal.dart';
import 'package:flutter/material.dart';

=======
import 'package:firstflut/dashboard.dart';
import 'package:flutter/material.dart';

//import 'buildExpensesPage.dart';
>>>>>>> 8b2652a213748d64e31f7b2ee7d7f26752eaad92

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ACoin',
      theme:  ThemeData.light().copyWith(
          inputDecorationTheme:
              InputDecorationTheme(
                border: OutlineInputBorder(),
                
              )
      ),
      home: new MyHomePage(title: 'ACoin'),
         );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Modal modal = new Modal();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Welcome to ACoin',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () =>  modal.mainBottomSheet(context),
        child: new Icon(Icons.add),
      ),
=======
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
>>>>>>> 8b2652a213748d64e31f7b2ee7d7f26752eaad92
    );
  }
}

