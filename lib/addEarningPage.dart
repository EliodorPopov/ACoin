import 'package:firstflut/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddEarningPage extends StatefulWidget {
  AddEarningPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddEarningPageState createState() => new _AddEarningPageState();
}

class _AddEarningPageState extends State<AddEarningPage> {
  final formKey = GlobalKey<FormState>();
  String _name, _source, _value;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();

  DbContext _context = new DbContext();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name:'),
                onSaved: (input) => _name = input,
                validator: (input) => input.isEmpty ? 'enter value' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value: (MDL)'),
                onSaved: (input) => _value = input,
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? 'enter value' : null,
              ),
              DateTimePickerFormField(
                format: dateFormat,
                initialValue: _date,
                editable: false,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (dt) => setState(() => _date = dt),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Source:'),
                onSaved: (input) => _source = input,
                validator: (input) => input.isEmpty ? 'enter value' : null,
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      print(_name);
      _context.updateIncomeTable(
          _name, int.tryParse(_value), _source, _date, true);
      _showAlert();
    }
  }

  void _showAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Information submitted!"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: new Text('OK!'))
            ],
          );
        });
  }
}
