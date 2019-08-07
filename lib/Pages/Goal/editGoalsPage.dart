import 'package:acoin/utils/db_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class EditGoalsPage extends StatefulWidget {
  EditGoalsPage(
      {Key key,
      this.title,
      this.id,
      this.name,
      this.value,
      this.target
      })
      : super(key: key);
  final String name , title;
  final int id , value, target;

  @override
  _EditGoalsPageState createState() => new _EditGoalsPageState();
}

class _EditGoalsPageState extends State<EditGoalsPage> {
  final formKey = GlobalKey<FormState>();
  String _name, _target;

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
                  initialValue: widget.name,
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
                decoration: InputDecoration(labelText: 'added target: (MDL)'),
                onSaved: (input) => _target = input,
                initialValue: widget.target.toString(),
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
      _context.editGoals(widget.id, _name,0, int.tryParse(_target));
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
                _context.deleteGoal(widget.id);
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