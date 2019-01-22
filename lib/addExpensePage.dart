import 'package:acoin/categoriesPage.dart';
import 'package:acoin/category.dart';
import 'package:acoin/db_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddExpensePage extends StatefulWidget {
  AddExpensePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddExpensePageState createState() => new _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  String _name, _value, _category = '', _path = 'images/noimage.png';
  int _categoryId;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();
  DbContext _context;
  List<String> _categories = new List<String>();

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
                  }),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                      decoration: InputDecoration(
                        //icon: const Icon(Icons.color_lens),
                        labelText: 'Category',
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      //isEmpty: _color == '',
                      child: selectCategory());
                },
                validator: (val) {
                  return _category != '' ? null : "Please select a category";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value:'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: _submit,
                      child: Text('Submit'),
                    ),
                  ),
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
      _context.addExpense(
          _name, int.tryParse(_value), _date, _categoryId);
      Navigator.pop(context, true); 
    }
  }

  Widget selectCategory() {
    if (_category == '')
      return RaisedButton(
        child: Text(
          'Select category',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          Map res = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => CategoriesPage()));
          if (res.toString() != 'null') {
            print(res['name'] + ' ' + res['path']);
            _category = res['name'];
            _path = res['path'];
          }
        },
        color: Colors.indigo[500],
      );
    else
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(_category, textScaleFactor: 1.3,),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints.expand(width: 50.0, height: 50.0),
              child: Image.asset(_path),
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
                          builder: (context) => CategoriesPage()));
                  if (res.toString() != 'null') {
                    print(res['name'] + ' ' + res['path']);
                    _category = res['name'];
                    _path = res['path'];
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
