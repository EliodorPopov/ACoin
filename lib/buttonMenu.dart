import 'package:firstflut/addearningPage.dart';
import 'package:firstflut/addexpensePage.dart';
import 'package:firstflut/addincomePage.dart';
import 'package:flutter/material.dart';

// TODO Is this still used? remove perhaps
class Modal {
  VoidCallback onRecurrentIncomeAdded;
  VoidCallback onExpenseAdded;
  VoidCallback onIncomeAdded;

  Modal({this.onRecurrentIncomeAdded, this.onExpenseAdded, this.onIncomeAdded});

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(
                  context, 'Add Recurrent Income', Icons.monetization_on, _addRecurrentIncome),
              _createTile(context, 'Add Expense', Icons.money_off, _addExpense),
              _createTile(context, 'Add Income', Icons.money_off, _addIncome),
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

  _addRecurrentIncome(BuildContext context) {
    var route =
        MaterialPageRoute(builder: (c) => AddEarningPage(title: "Add Recurrent Income"));
    Navigator.pop(context);
    Navigator.push(context, route).then((_) {
      if (onRecurrentIncomeAdded != null) onRecurrentIncomeAdded(); 
    });
  }

  _addIncome(BuildContext context) {
    var route =
        MaterialPageRoute(builder: (c) => AddIncomePage(title: "Add Income"));
    Navigator.pop(context);
    Navigator.push(context, route).then((_) {
      if (onIncomeAdded != null) onIncomeAdded();
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