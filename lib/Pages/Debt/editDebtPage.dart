import 'package:acoin/utils/db_context.dart';
import 'package:acoin/Models/debt.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDebtPage extends StatefulWidget {
  EditDebtPage({
    Key key,
    this.title,
    this.dbId,
    this.dbPName,
    this.dbDebtValue,
    this.dbDate,
    this.dbDeadlineDate,
  }) : super(key: key);
  final int dbId, dbDebtValue;
  final String dbPName;
  final DateTime dbDate, dbDeadlineDate;
  final String title;

  @override
  _EditDebtPageState createState() => new _EditDebtPageState();
}

class _EditDebtPageState extends State<EditDebtPage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  String _pname, _debtvalue;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now();
  DateTime _deadlinedate;
  DbContext _context;
  List<Debt> _debts = new List<Debt>();
  List<DropdownMenuItem<String>> dropList = [
    new DropdownMenuItem<String>(value: 'Yes', child: new Text('Yes')),
    new DropdownMenuItem<String>(value: 'No', child: new Text('No'))
  ];
  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readDebts().then((list) {
      setState(() {
        _debts = list;
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
                  decoration:
                      InputDecoration(labelText: 'Creditor/Lender Name:'),
                  initialValue: widget.dbPName,
                  onSaved: (input) => _pname = input,
                  validator: (input) {
                    if (input.length == 0) {
                      return 'Please add a name';
                    }
                  }),
              TextFormField(
                initialValue: widget.dbDebtValue.toString(),
                decoration: InputDecoration(labelText: 'Debt Value:'),
                onSaved: (input) => _debtvalue = input,
                keyboardType: TextInputType.number,
                validator: (input) =>
                    input.isEmpty ? 'enter value please' : null,
              ),
              DateTimePickerFormField(
                format: dateFormat,
                initialValue: widget.dbDate,
                editable: false,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (dt) => setState(() => _date = dt),
              ),
              DateTimePickerFormField(
                format: dateFormat,
                initialValue: widget.dbDeadlineDate,
                editable: false,
                decoration: InputDecoration(labelText: 'Deadline Date'),
                onChanged: (dt) => setState(() => _deadlinedate = dt),
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
      print(_pname);
      if (widget.dbPName != _pname ||
          widget.dbDebtValue != int.tryParse(_debtvalue) ||
          widget.dbDate != _date ||
          widget.dbDeadlineDate != _deadlinedate) {
        _context.editDebt(
          widget.dbId,
          _pname,
          int.tryParse(_debtvalue),
          _date,
          _deadlinedate,
        );
      }
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
                    _context.deleteDebt(widget.dbId);
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
                    _context.deleteDebt(widget.dbId);
                    Navigator.pop(context, true);
                  },
                  child: new Text('Yes!')),
            ],
          );
        });
  }
}
