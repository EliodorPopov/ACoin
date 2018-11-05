import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
class EarningsPage extends StatefulWidget {
  EarningsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EarningsPageState createState() => new _EarningsPageState();
}
class _EarningsPageState extends State<EarningsPage> {
  final formKey = GlobalKey<FormState>();
  String _name, _source, _value;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Value:'
                    ),
                    onSaved: (input) => _value = input,
                  ),
                  
                   DateTimePickerFormField(
              format: dateFormat,
              decoration: InputDecoration(labelText: 'Date'),
              onChanged: (dt) => setState(() => date = dt),
            ),
                  
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
                        padding: const EdgeInsets.all(10.0),
                        child: RaisedButton(
                          onPressed: _submit,
                          child: Text('Submit'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        );
  }

  void _submit(){
      print(_name);
    }
  }