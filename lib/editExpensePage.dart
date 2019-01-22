import 'package:acoin/categoriesPage.dart';
import 'package:acoin/category.dart';
import 'package:acoin/db_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EditExpensePage extends StatefulWidget {
  EditExpensePage({
    Key key,
    this.title,
    this.dbId,
    this.dbName,
    this.dbValue,
    this.dbDate,
    this.dbCategory,
  }) : super(key: key);
  final int dbId, dbValue;
  final String dbName, dbCategory;
  final DateTime dbDate;
  final String title;

  @override
  _EditExpensePageState createState() => new _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  String _name, _value, _category, _path;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();
  DbContext _context;
  List<Category> _categories = new List<Category>();

  @override
  initState() {
    super.initState();
    readCategories();
  }

  void readCategories() async {
    _context = new DbContext();
    await _context.readCategories().then((list) {
      setState(() {
        _categories = list;
      });
    });
    _category = '';
    _path = 'images/noimage.png';
    for (var c in _categories) {
      print(c.name + ' ' + widget.dbCategory);
      if (c.name == widget.dbCategory) {
        _category = widget.dbCategory;
        _path = c.path;
        break;
      }
    }
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
                  initialValue: widget.dbName,
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
                        labelText: 'Category',
                      ),
                      child: selectCategory());
                },
                validator: (val) {
                  return _path != 'images/noimage.png'
                      ? null
                      : "Please select a category";
                },
              ),
              TextFormField(
                initialValue: widget.dbValue.toString(),
                decoration: InputDecoration(labelText: 'Value:'),
                onSaved: (input) => _value = input,
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
      if (widget.dbName != _name ||
          widget.dbValue != int.tryParse(_value) ||
          widget.dbDate != _date ||
          widget.dbCategory != _category) {
        _context.editExpense(
            widget.dbId, _name, int.tryParse(_value), _date, _category);
      }
      Navigator.pop(context, false);
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
              child: Text(
                _category,
                textScaleFactor: 1.3,
              ),
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
                    _context.deleteExpense(widget.dbId);
                    Navigator.pop(context, true);
                  },
                  child: new Text('Yes!')),
            ],
          );
        });
  }

  Future<bool> _submitDelete2() {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text("Are you sure you want to delete ?"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: new Text('No!')),
              new FlatButton(
                  onPressed: () {
                    _context.deleteExpense(widget.dbId);
                    Navigator.pop(context, true);
                  },
                  child: new Text('Yes!')),
            ],
          );
        });
  }
}
