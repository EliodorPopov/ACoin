import 'package:acoin/db_context.dart';
import 'package:acoin/debt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime _date = DateTime.now(), _deadlinedate;
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
              DateTimePickerFormField(
                format: dateFormat,
                initialValue: _date,
                editable: false,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (dt) => setState(() => _date = dt),
              ),
              DateTimePickerFormField(
                format: dateFormat,
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
    );
  }

  void _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _context.addDebt(
        _pname,
        int.tryParse(_debtvalue),
        _date,
        _deadlinedate,
      );
      Navigator.pop(context, true);
    }
  }
}
