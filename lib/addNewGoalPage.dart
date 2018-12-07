import 'package:flutter/material.dart';

class addNewGoalPage extends StatefulWidget {
  addNewGoalPage({Key key}) : super(key: key);
  
  @override
  _addNewGoalPageState createState() => new _addNewGoalPageState();
}

class _addNewGoalPageState extends State<addNewGoalPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add new goal"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        
      ),
      
    );
  }
}
