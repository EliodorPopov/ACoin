import 'package:acoin/expense.dart';
import 'package:acoin/db_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _name, _value, _category, _newCategory;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();
  DbContext _context;
  List<String> _categories = new List<String>();
  List<Expense> _expenses = new List<Expense>();

  @override
  initState() {
    super.initState();
    bool isTrue = true;
    _category = widget.dbCategory;
    _context = new DbContext();
    _context.readExpense("All time").then((list) {
      setState(() {
        _expenses = list;
        _expenses.forEach((e) {
          _categories.forEach((f) {
            if (f == e.category) isTrue = false;
          });
          if (isTrue) _categories.add(e.category);
          isTrue = true;
        });
        _categories.add("Add Category");
      });
    });
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
                      //icon: const Icon(Icons.color_lens),
                      labelText: 'Category',
                      errorText: state.hasError ? state.errorText : null,
                    ),
                    //isEmpty: _color == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        value: _category,
                        isDense: true,
                        onChanged: (e) async {
                          if (e == "Add Category") {
                            await _createCategory();
                          } else
                            _category = e;
                          setState(() {});
                        },
                        items: _categories.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (val) {
                  return val != _category ? null : "Please select a category";
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
        onPressed: () => _submitDelete2().then((value) {
              if (value) Navigator.pop(context, true);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(_name);
      _context.editExpense(
          widget.dbId, _name, int.tryParse(_value), _date, _category);
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
                    _context.deleteExpense(widget.dbId);
                    Navigator.pop(context, true);
                  },
                  child: new Text('Yes!')),
            ],
          );
        });
  }

  Future _createCategory() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Category"),
          contentPadding: EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey2,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Name:'),
                  onSaved: (input) {
                    _newCategory = input;
                  },
                  onFieldSubmitted: (e) {
                    _newCategory = e;
                  },
                  validator: (input) => input.isEmpty ? 'enter value' : null,
                ),
              ),
              RaisedButton(
                child: Text("Add"),
                onPressed: () {
                  if (formKey2.currentState.validate()) {
                    formKey2.currentState.save();
                    _categories.removeLast();
                    _categories.add(_newCategory);
                    _category = _newCategory;
                    _newCategory = null;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
