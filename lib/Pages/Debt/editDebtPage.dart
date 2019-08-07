import 'package:acoin/utils/db_context.dart';
import 'package:acoin/Models/debt.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:acoin/utils/cupertinoDate.dart';

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
  final dateFormat = DateFormat("EE, MMMM d, yyyy, k:mm");
  DateTime _date = DateTime.now();
  DateTime _deadlinedate;
  DbContext _context;
  List<Debt> _debts = new List<Debt>();
  var dateController = new TextEditingController();
  var deadlineDateController = new TextEditingController(text: "");
  List<DropdownMenuItem<String>> dropList = [
    new DropdownMenuItem<String>(value: 'Yes', child: new Text('Yes')),
    new DropdownMenuItem<String>(value: 'No', child: new Text('No'))
  ];
  @override
  initState() {
    super.initState();
    _context = new DbContext();
    dateController.text = dateFormat.format(widget.dbDate);
    deadlineDateController.text = dateFormat.format(widget.dbDeadlineDate);
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
              GestureDetector(
                onTap: () {
                  getCupertinoDate(context, dateController, _date, dateFormat)
                      .then((newDate) {
                    _date = newDate;
                  });
                },
                child: Container(
                  color: Colors.white10,
                  child: IgnorePointer(
                    child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(labelText: 'Date')),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getCupertinoDate(
                          context, deadlineDateController, null, dateFormat)
                      .then((newDate) {
                    _deadlinedate = newDate;
                  });
                },
                child: Container(
                  color: Colors.white10,
                  child: IgnorePointer(
                    child: TextFormField(
                        controller: deadlineDateController,
                        decoration:
                            InputDecoration(labelText: 'Deadline Date')),
                  ),
                ),
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
          _deadlinedate ?? DateTime(2030,1,1),
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
