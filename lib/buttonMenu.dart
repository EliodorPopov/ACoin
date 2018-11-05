import './addEarningPage.dart';
import './addExpensePage.dart';
import 'package:flutter/material.dart';

class Modal {
  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(
                  context, 'Add Income', Icons.monetization_on, _action1),
              _createTile(context, 'Add Expense', Icons.money_off, _action2),
            ],
          );
        });
  }

  ListTile _createTile(
      BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        action(context);
      },
    );
  }

  _action1(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (c) => AddEarningPage(title: "Add Income")));
  }

  _action2(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => AddExpensePage(title: "Add Expense")));
  }
}
