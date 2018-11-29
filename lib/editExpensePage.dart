import 'package:firstflut/expense.dart';
import 'package:firstflut/db_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// TODO lots of code repetition, try to merge add page and edit page, or at least parts of it
class EditExpensePage extends StatefulWidget {
  EditExpensePage(
      {Key key,
      this.title,
      this.dbId,
      this.dbName,
      this.dbValue,
      this.dbDate,
      this.dbCategory})
      : super(key: key);
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
  //List<String> _test = <String>['test', 'test2', 'test3'];
  List<Expense> _expenses = new List<Expense>();

  @override
  initState() {
    super.initState();
    bool isTrue = true;
    _context = new DbContext();
    _context.readExpense().then((list) {
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
                      var check = true;
                      for (int i = 0; i < input.length; i++) {
                        // TODO needs rework, try using, change all the places with similar code
                        // inputFormatters: [
                        //   WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                        // ]
                        if ((input[i] == '0') ||
                            (input[i] == '1') ||
                            (input[i] == '2') ||
                            (input[i] == '3') ||
                            (input[i] == '4') ||
                            (input[i] == '5') ||
                            (input[i] == '6') ||
                            (input[i] == '7') ||
                            (input[i] == '8') ||
                            (input[i] == '9')) {
                          check = false;
                        }
                      }
                      if (!check) {
                        return 'Numele nu poate contine cifre...';
                      }
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
                        value: widget.dbCategory,
                        isDense: true,
                        onChanged: (e) {
                          if (e == "Add Category") {
                            _createCategory();
                            // _categories.removeLast();
                            // _categories.add(PopupCreateCategory.createCategory2(context).toString());
                            // _categories.add("Add Category");
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
        onPressed: _submitDelete,
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
      // _context.updateExpenseTable(
      //     _name, int.tryParse(_value), _date, _category);
      _showAlert();
    }
  }

  void _submitDelete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Are you sure you want to delete ?"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('No!')),
              new FlatButton(
                  onPressed: () {
                    _context.deleteExpense(widget.dbId);
                    _deletedConfirm();
                  },
                  child: new Text('Yes!')),
            ],
          );
        });
  }

  void _deletedConfirm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Deleted!"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: new Text('OK!'))
            ],
          );
        });
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

  void _createCategory() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Category"),
            contentPadding: EdgeInsets.all(10.0),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Form(
                key: formKey2,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Name:'),
                  onSaved: (input) {
                    _newCategory = input;
                    print(input);
                  },
                  onFieldSubmitted: (e) {
                    _newCategory = e;
                    print(e);
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
                    setState(() {});
                    //return _addedCategory;
                    //Navigator.pop(context);
                    //return _addedCategory;
                    //Navigator.pop(context);
                    print("printed");
                  }
                  print(_newCategory);
                },
              ),
            ]),
          );
        });
  }
}
