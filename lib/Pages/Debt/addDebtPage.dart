import 'package:acoin/utils/db_context.dart';
import 'package:acoin/Models/debt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:acoin/utils/cupertinoDate.dart';

class AddDebtPage extends StatefulWidget {
  AddDebtPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddDebtPageState createState() => new _AddDebtPageState();
}

class _AddDebtPageState extends State<AddDebtPage> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  String _pname, _debtvalue;
  final dateFormat = DateFormat("EE, MMMM d, yyyy, k:mm");
  DateTime _date = DateTime.now(), _deadlinedate;
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
    _context.readDebts().then((list) {
      setState(() {
        _debts = list;
      });
    });
    dateController.text = dateFormat.format(_date);
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
                      InputDecoration(labelText: 'Creditor/Lender name:'),
                  onSaved: (input) => _pname = input,
                  validator: (input) {
                    if (input.length == 0) {
                      return 'Please add a name';
                    }
                  }),
              TextFormField(
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
                  getCupertinoDate(context, deadlineDateController, null, dateFormat)
                      .then((newDate) {
                    _deadlinedate = newDate;
                  });
                },
                child: Container(
                  color: Colors.white10,
                  child: IgnorePointer(
                    child: TextFormField(
                        controller: deadlineDateController,
                        decoration: InputDecoration(labelText: 'Deadline Date')),
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
    );
  }

  void _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _context.addDebt(
        _pname,
        int.tryParse(_debtvalue),
        _date,
        _deadlinedate ?? DateTime(2030,01,01),
      );
      Navigator.pop(context, true);
    }
  }
}
