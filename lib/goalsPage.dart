import 'package:flutter/material.dart';
import 'package:acoin/addNewGoalPage.dart';

class GoalsPage extends StatefulWidget {
  GoalsPage({Key key}) : super(key: key);

  @override
  _GoalsPageState createState() => new _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Goals"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        
      ),
      floatingActionButton: new FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>addNewGoalPage()));
            },
            child: new IconTheme(
              data: new IconThemeData(
              color: Color(0xFFFFFFFF)
              ),
            child: new Icon(Icons.add),
          ),
      )
    );
  }
}
