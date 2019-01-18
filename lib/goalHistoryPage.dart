import 'package:flutter/material.dart';

class GoalHistoryPage extends StatefulWidget {
  GoalHistoryPage({Key key}) : super(key: key);

  @override
  _GoalHistoryPageState createState() => new _GoalHistoryPageState();
}

class _GoalHistoryPageState extends State<GoalHistoryPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("History"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset('images/piggy.png')
              ),
            ),
          ],
        ),
      ),
    );
  }
}
