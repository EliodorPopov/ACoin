import 'package:acoin/utils/db_context.dart';
import 'package:acoin/Models/debt.dart';
import 'package:flutter/cupertino.dart';
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
  final dateFormat = DateFormat("EE, MMMM d, yyyy, k:mm");
  DateTime _date = DateTime.now(), _deadlinedate;
  DbContext _context;
  List<Debt> _debts = new List<Debt>();
  var dateController = new TextEditingController();
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
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              initialDateTime: _date,
                              onDateTimeChanged: (DateTime newdate) {
                                _date = newdate;
                              },
                              use24hFormat: true,
                              maximumDate: new DateTime(2020, 12, 30),
                              minimumYear: 2010,
                              maximumYear: 2020,
                              minuteInterval: 1,
                              mode: CupertinoDatePickerMode.dateAndTime,
                            ));
                      }).then((_) {
                    dateController.text = dateFormat.format(_date);
                  });
                },
                child: Container(
                  color: Colors.white10,
                  child: IgnorePointer(
                    child: TextFormField(
                      enabled: true,
                      controller: dateController,
                      //initialValue: dateFormat.format(_date),
                      decoration: InputDecoration(labelText: 'Date'),
                      onFieldSubmitted: (f) => f = dateFormat.format(_date),
                      autovalidate: true,
                      validator: (val) {
                        if (val != dateFormat.format(_date))
                          val = dateFormat.format(_date);
                      },
                    ),
                  ),
                ),
              ),
              DateTimePickerFormField(
                inputType: InputType.both,
                format: dateFormat,
                initialValue: _date,
                editable: false,
                decoration: InputDecoration(labelText: 'Date'),
                onChanged: (dt) => setState(() => _date = dt),
              ),
              DateTimePickerFormField(
                // autofocus: false,
                keyboardType: TextInputType.url,
                autofocus: false,
                // focusNode: ,
                inputType: InputType.both,
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
