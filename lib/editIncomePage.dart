import 'package:acoin/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class EditIncomePage extends StatefulWidget {
  EditIncomePage(
      {Key key,
      this.title,
      this.dbId,
      this.dbName,
      this.dbValue,
      this.dbDate,
      this.dbSource,
      this.isRecurrent})
      : super(key: key);
  final String title;
  final int dbId, dbValue;
  final String dbName, dbSource;
  final DateTime dbDate;
  final bool isRecurrent;

  @override
  _EditIncomePageState createState() => new _EditIncomePageState();
}

class _EditIncomePageState extends State<EditIncomePage> {
  final formKey = GlobalKey<FormState>();
  String _name, _source, _value;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();

  DbContext _context = new DbContext();
  @override
  initState() {
    super.initState();
    _context = new DbContext();
  }

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
                  initialValue: widget.dbName,
                  onSaved: (input) => _name = input,
                  validator: (input) {
                    if (input.length == 0) {
                      return 'Adaugati Valoare';
                    } else {
                      if(!(input.contains(new RegExp(
                        r'[A-Z]',
                        caseSensitive: false,
                      )))){
                        return 'Numele nu poate contine alte caractere decit litere...';
                      }
                    }
                  }),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value: (MDL)'),
                onSaved: (input) => _value = input,
                initialValue: widget.dbValue.toString(),
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? 'enter value' : null,
              ),
              DateTimePickerFormField(
                format: dateFormat,
                initialValue: widget.dbDate,
                editable: false,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (dt) => setState(() => _date = dt),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Source:'),
                initialValue: widget.dbSource,
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
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.delete_sweep),
        backgroundColor: Colors.red,
        onPressed: () => _submitDelete().then((value) {
              if (value) Navigator.pop(context, true);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _context.editIncome(widget.dbId, _name, int.tryParse(_value), _date,
          _source, widget.isRecurrent);
      Navigator.pop(context, false);
    }
  }

  Future<bool> _submitDelete() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to delete ?"),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: new Text('No!')),
            new FlatButton(
              onPressed: () {
                _context.deleteIncome(widget.dbId, widget.isRecurrent);
                Navigator.pop(context, true);
              },
              child: new Text('Yes!'),
            ),
          ],
        );
      },
    );
  }
}
