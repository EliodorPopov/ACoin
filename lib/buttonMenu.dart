import 'package:firstflut/addEarningPage.dart';
import 'package:firstflut/addExpensePage.dart';
import 'package:flutter/material.dart';

class Modal {
  VoidCallback onEarningAdded;
  VoidCallback onExpenseAdded;

  Modal({this.onEarningAdded, this.onExpenseAdded});

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(
                  context, 'Add Income', Icons.monetization_on, _addEarning),
              _createTile(context, 'Add Expense', Icons.money_off, _addExpense),
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

  _addEarning(BuildContext context) {
    var route =
        MaterialPageRoute(builder: (c) => AddEarningPage(title: "Add Income"));
    Navigator.pop(context);
    Navigator.push(context, route).then((_) {
      if (onEarningAdded != null) onEarningAdded();
    });
  }

  _addExpense(BuildContext context) {
    var route =
        MaterialPageRoute(builder: (c) => AddExpensePage(title: "Add Expense"));

    Navigator.pop(context);
    Navigator.push(context, route).then((_) {
      if (onExpenseAdded != null) onExpenseAdded();
    });
  }
}
