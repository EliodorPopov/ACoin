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
  String _name, _value, _category, _newCategory;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();
  DbContext _context;
  List<String> _categories = new List<String>();

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readExpense("All time").then((list) {
      setState(() {
        _categories =
            list.map((e) => e.category).toSet().toList(growable: true);
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
                        items: _categories.map(
                          (String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                },
                validator: (val) {
                  return val != _category ? null : "Please select a category";
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

  void _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _context.addExpense(
          _name, int.tryParse(_value), _date, _category);
      Navigator.pop(context, true); 
    }
  }

  Future _createCategory() {
    return showDialog(
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
                  print("category added: "+_category);
                }
              },
            ),
          ]),
        );
      },
    );
  }
}
