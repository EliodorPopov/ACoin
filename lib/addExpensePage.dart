import 'package:firstflut/db_context.dart';
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
  String _name, _value;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();

  DbContext _context = new DbContext();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name:'),
                onSaved: (input) => _name = input,
                validator: (input) => input.isEmpty ? 'enter value' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value:'),
                onSaved: (input) => _value = input,
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? 'enter value' : null,
              ),
              DateTimePickerFormField(
                format: dateFormat,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (dt) => setState(() => _date = dt),
                initialValue: _date,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: _submit,
                      child: Text('Submit'),
                    ),
                  )
                ],
              ),
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
      _context.updateTableRaw(_name, int.tryParse(_value), _date);
      _showAlert();
    }
  }

  void _showAlert() {
    showDialog(
        context: context,
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
