import 'package:acoin/utils/db_context.dart';
import 'package:flutter/material.dart';

class AddNewGoalPage extends StatefulWidget {
  AddNewGoalPage({Key key}) : super(key: key);
  
  @override
  _AddNewGoalPageState createState() => new _AddNewGoalPageState();
}

class _AddNewGoalPageState extends State<AddNewGoalPage> {
  final formKey = GlobalKey<FormState>();
  String _name, _target;
  DbContext _context = new DbContext();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add new goal"),
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
                  } else {
                      if(!(input.contains(new RegExp(
                        r'[A-Z]',
                        caseSensitive: false,
                      )))) {
                        return 'Numele nu poate contine alte caractere decit litere...';
                      }
                    }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Target: (MDL)'),
                onSaved: (input) => _target = input,
                keyboardType: TextInputType.number,
                validator: (input) => input.isEmpty ? 'enter target' : null,
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
      _context.addGoal(_name,int.tryParse(_target));
      Navigator.pop(context, true);
    }
  }
}