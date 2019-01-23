import 'package:acoin/categoriesPage.dart';
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
      this.dbSourceId,
      this.dbSourceName,
      this.dbSourcePath,
      this.isRecurrent})
      : super(key: key);
  final String title;
  final int dbId, dbValue, dbSourceId;
  final String dbName, dbSourceName, dbSourcePath;
  final DateTime dbDate;
  final bool isRecurrent;

  @override
  _EditIncomePageState createState() => new _EditIncomePageState();
}

class _EditIncomePageState extends State<EditIncomePage> {
  final formKey = GlobalKey<FormState>();
  String _name, _sourceName, _value, _sourcePath;
  int _sourceId;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();

  DbContext _context = new DbContext();
  @override
  initState() {
    super.initState();
    _sourceId = widget.dbSourceId;
    _sourcePath = widget.dbSourcePath;
    _sourceName = widget.dbSourceName;
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
                      if (!(input.contains(new RegExp(r'[A-Z][a-z]')))) {
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
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Source',
                      ),
                      child: selectSource());
                },
                validator: (val) {
                  return _sourcePath != 'images/noimage.png'
                      ? null
                      : "Please select a category";
                },
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
          _sourceId, widget.isRecurrent);
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

  Widget selectSource() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text(
              _sourceName,
              textScaleFactor: 1.3,
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        Expanded(
          child: Container(
            constraints: BoxConstraints.expand(width: 50.0, height: 50.0),
            child: Image.asset(_sourcePath),
            alignment: Alignment.center,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              child: Text(
                'Change',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Map res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoriesPage(
                              categoryStatus: 2,
                            )));
                if (res.toString() != 'null') {
                  print(res['name'] + ' ' + res['path']);
                  _sourceName = res['name'];
                  _sourcePath = res['path'];
                  _sourceId = res['id'];
                }
              },
              color: Colors.indigo[500],
            ),
          ),
        ),
      ],
    );
  }
}
