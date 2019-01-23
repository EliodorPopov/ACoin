import 'package:acoin/categoriesPage.dart';
import 'package:acoin/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddIncomePage extends StatefulWidget {
  AddIncomePage({Key key, this.title, this.isRecurrent}) : super(key: key);
  final String title;
  final bool isRecurrent;

  @override
  _AddIncomePageState createState() => new _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final formKey = GlobalKey<FormState>();
  String _name, _sourceName = '', _value, _sourcePath = 'images/noimage.png';
  int _sourceId;
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
                validator: (input) {
                  if (input.length == 0) {
                    return 'Adaugati Valoare';
                  }
                },
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
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _context.addIncome(
          _name, int.tryParse(_value), _sourceId, _date, widget.isRecurrent);
      Navigator.pop(context, true);
    }
  }

  Widget selectSource() {
    if (_sourceName == '')
      return RaisedButton(
        child: Text(
          'Select source',
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
      );
    else
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
