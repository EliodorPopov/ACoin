import 'package:acoin/db_context.dart';
import 'package:acoin/goal.dart';
import 'package:flutter/material.dart';
import 'package:acoin/AddNewGoalPage.dart';

class GoalsPage extends StatefulWidget {
  GoalsPage({Key key}) : super(key: key);

  @override
  _GoalsPageState createState() => new _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  DbContext _context;
  List<Goal> _goals = new List<Goal>();

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readGoals().then((list) {
      setState(() {
        _goals = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Goals"),
      ),
      body: new Center(
        child: new ListView(
          children: _goals.map(
            (i) {
              return GestureDetector(
                // onTap: () => Navigator.push(
                //       context,
                //       SlideLeftRoute(
                //         widget: EditExpensePage(
                //           title: "edit expense",
                //           dbId: i.id,
                //           dbCategory: i.category,
                //           dbDate: i.date,
                //           dbName: i.name,
                //           dbValue: i.value,
                //         ),
                //       ),
                //     ).then((isSuccessful) {
                //       if (isSuccessful)
                //         _showSuccessSnackBar("Deleted!", true);
                //       else
                //         _showSuccessSnackBar("Saved!", false);
                //     }).then(
                //       (e) => _context.readExpense().then((list) {
                //             setState(() {
                //               _goals = list;
                //             });
                //           }),
                //     ),
                child: ListTile(
                  title: Text(
                    i.name + " [" + i.value.toString() + "]",
                    textScaleFactor: 3.0,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>AddNewGoalPage()));
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
