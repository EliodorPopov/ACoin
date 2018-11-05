import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
class ExpensesPage extends StatefulWidget {
  ExpensesPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExpensesPageState createState() => new _ExpensesPageState();
}
class _ExpensesPageState extends State<ExpensesPage> {
  final formKey = GlobalKey<FormState>();
  String _name, _source, _value; 
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime date;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name:'
                    ),
                    onSaved: (input) => _name = input,
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Value:'
                    ),
                    onSaved: (input) => _value = input,
                  ),
                  SizedBox(height: 12.0),               
                   DateTimePickerFormField(
              format: dateFormat,
              decoration: InputDecoration(labelText: 'Date'
              ),
              onChanged: (dt) => setState(() => date = dt)
            ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Source:'
                    ),
                    onSaved: (input) => _source = input,
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: _submit,
                          child: Text('Submit'),
                           shape: BeveledRectangleBorder(
                           borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  

  void _submit(){
      print(_name);
    }
} 
