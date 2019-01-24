import 'package:acoin/db_context.dart';
import 'package:acoin/editGoalsPage.dart';
import 'package:acoin/goal.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:acoin/AddNewGoalPage.dart';

class GoalsPage extends StatefulWidget {
  GoalsPage({Key key}) : super(key: key);

  @override
  _GoalsPageState createState() => new _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  DbContext _context;
  double duelCommandment = 1.0;
  List<Goal> _goals = new List<Goal>();
  int value,target;

  void _showSuccessSnackBar(String message, bool color) {
    Flushbar(flushbarPosition: FlushbarPosition.TOP)
      ..message = message
      ..icon = Icon(
        Icons.done,
        size: 28.0,
        color: color ? Colors.red : Colors.green,
      )
      ..isDismissible = false
      ..duration = Duration(seconds: 2)
      ..leftBarIndicatorColor = color ? Colors.red : Colors.green
      ..show(context);
  }

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
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onLongPress: () => Navigator.push(
                            context,
                            SlideLeftRoute(
                              widget: EditGoalsPage(
                                title: "edit Goal",
                                id: i.id,
                                name: i.name,
                                value: i.value,
                                target: i.target,
                              ),
                            ),
                          ).then((isSuccessful) {
                            if (isSuccessful)
                              _showSuccessSnackBar("Deleted!", true);
                            else
                              _showSuccessSnackBar("Saved!", false);
                          }).then(
                            (e) => _context.readGoals().then((list) {
                                  setState(() {
                                    _goals = list;
                                  });
                                }),
                          ),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: new Text(
                              i.name,
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          new Container(
                            child: new LinearProgressIndicator(
                              value: (i.value/i.target).clamp(0.0, 1.0),
                              backgroundColor: Colors.indigo[200],
                              valueColor: null,
                            ),
                            padding: EdgeInsets.all(5.0),
                          ),
                          new Row(
                            children: [
                              new Expanded(
                                child: new Container(
                                  child: Text(i.value.toString() + " lei"),
                                  padding: EdgeInsets.all(5.0),
                                ),
                              ),
                              new Expanded(
                                child: new Container(
                                  child: Text(
                                              (i.value / i.target * 100).toStringAsFixed(0) +
                                      "%"),
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                ),
                              ),
                              new Expanded(
                                child: new Container(
                                  child: Text(i.target.toString() + " lei"),
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(
                                "Add money to your dream!",
                              ),
                              content: new CustomDialogSliderContent(
                                onValueSelected: (value) {
                                  if (value == null) return;
                                  var result = i.value + value.round();
                                  setState(() {
                                    i.value = result;
                                  });
                                  _context.chageGoalsValue(i.id, result);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNewGoalPage()))
                .then((rs) {
              _context.readGoals().then((list) {
                setState(() {
                  _goals = list;
                });
              });
            });
          },
          child: new IconTheme(
            data: new IconThemeData(color: Color(0xFFFFFFFF)),
            child: new Icon(Icons.add),
          ),
        ));
  }
}

class CustomDialogSliderContentState extends State<CustomDialogSliderContent> {
  double duelCommandment = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(width: 300.0, height: 80.0),
      child: new Column(
        children: <Widget>[
          Slider(
            value: duelCommandment,
            min: 0.0,
            max: 5000.0,
            divisions: 10,
            label: '$duelCommandment',
            onChanged: (newValue) {
              setState(() {
                duelCommandment = newValue;
              });
            },
          ),
          Container(
            child: RaisedButton(
              onPressed: () {
                widget.onValueSelected(duelCommandment);
                Navigator.pop(context);
              },
              splashColor: Colors.green,
              color: Colors.green,
              child: new Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

typedef DoubleCallback = void Function(double data);

class CustomDialogSliderContent extends StatefulWidget {
  final DoubleCallback onValueSelected;
  const CustomDialogSliderContent({
    Key key,
    @required this.onValueSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CustomDialogSliderContentState();
  }
}
