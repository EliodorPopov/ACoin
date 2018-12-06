import 'package:flutter/material.dart';
import 'package:acoin/addNewGoalPage.dart';

class goalsPage extends StatefulWidget {
  goalsPage({Key key}) : super(key: key);

  @override
  _goalsPageState createState() => new _goalsPageState();
}

class _goalsPageState extends State<goalsPage> {
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
