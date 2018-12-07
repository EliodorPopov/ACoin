import 'package:acoin/expense.dart';
import 'package:acoin/income.dart';
import 'package:acoin/recurrentIncome.dart';
import 'package:acoin/addExpensePage.dart';
import 'package:acoin/addIncomePage.dart';
import 'package:acoin/expensesHistoryPage.dart';
import 'package:acoin/incomeHistoryPage.dart';
import 'package:acoin/recurrentIncomeHistoryPage.dart';
import 'package:acoin/db_context.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:acoin/goalsPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flushbar/flushbar.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  ScrollController _scrollController;
  bool _dialVisible = true;
  DbContext _context;
  List<Expense> _expenses = new List<Expense>();
  List<Income> _incomes = new List<Income>();
  List<RecurrentIncome> _recurrentIncomes = new List<RecurrentIncome>();
  int currentBalance = 0;
  int totalIncomes = 0;
  int totalExpenses = 0;

  void _showSuccessSnackBar() {
    Flushbar(flushbarPosition: FlushbarPosition.TOP)
      ..message = 'Information submitted!'
      ..icon = Icon(
        Icons.done,
        size: 28.0,
        color: Colors.green,
      )
      ..duration = Duration(seconds: 2)
      ..leftBarIndicatorColor = Colors.green
      ..show(context);
  }

  _addRecurrentIncome(BuildContext context) {
    var route = MaterialPageRoute(
        builder: (c) =>
            AddIncomePage(title: "Add Recurrent Income", isRecurrent: true));
    Navigator.push(context, route).then((isSuccessful) async {
      if (isSuccessful) {
        await loadRecurrentIncome();
        calculateBalance();
        _showSuccessSnackBar();
      }
    });
  }

  _addIncome(BuildContext context) {
    var route = MaterialPageRoute(
        builder: (c) => AddIncomePage(title: "Add Income", isRecurrent: false));
    Navigator.push(context, route).then((isSuccessful) async {
      if (isSuccessful) {
        await loadIncome();
        calculateBalance();
        _showSuccessSnackBar();
      }
    });
  }

  _addExpense(BuildContext context) {
    var route =
        MaterialPageRoute(builder: (c) => AddExpensePage(title: "Add Expense"));
    Navigator.push(context, route).then((isSuccessful) async {
      if (isSuccessful == true) {
        await loadExpenses();
        calculateBalance();
        _showSuccessSnackBar();
      }
    });
  }

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    calculateBalance();
    _scrollController = ScrollController()
      ..addListener(
        () {
          _setDialVisible(_scrollController.position.userScrollDirection ==
              ScrollDirection.forward);
        },
      );

  }

  void calculateBalance() async {
    await loadRecurrentIncome();
    await loadExpenses();
    await loadIncome();
    currentBalance = 0;
    totalExpenses = 0;
    totalIncomes = 0;
    _expenses.forEach((e) {
      totalExpenses += e.value;
    });
    _incomes.forEach((e) {
      totalIncomes += e.value;
    });
    _recurrentIncomes.forEach((e) {
      if (e.isEnabled) {
        totalIncomes += e.value;
      }
    });
    currentBalance = totalIncomes - totalExpenses;
    print(currentBalance);
  }


  _setDialVisible(bool value) {
    setState(() {
      _dialVisible = value;
    });
  }

  _renderSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () {
        print('DIAL CLOSED');
        calculateBalance();
      },
      visible: _dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.monetization_on, color: Colors.white),
          backgroundColor: Colors.greenAccent,
          onTap: () => _addRecurrentIncome(context),
          label: 'Add Recurrent Income',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.greenAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.account_balance_wallet, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => _addIncome(context),
          label: 'Add Income',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.money_off, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () => _addExpense(context),
          label: 'Add Expense',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.redAccent,
        ),
      ],
    );
  }

  Future<Null> loadExpenses() {
    return _context.readExpense().then((list) {
      setState(() {
        _expenses = list;
      });
    });
  }

  Future<Null> loadIncome() {
    return _context.readIncome().then((list) {
      setState(() {
        _incomes = list;
      });
    });
  }


  Future<Null> loadRecurrentIncome() {
    return _context.readRecurrentIncome().then((list) {
      setState(() {
        _recurrentIncomes = list;
      });
    });
  }


  List<charts.Series<Expense, String>> expensesListDB() {
    return [
      new charts.Series<Expense, String>(
        id: 'Sales',
        domainFn: (Expense sales, _) => sales.name,
        measureFn: (Expense sales, _) => sales.value ?? 0,
        data: _expenses,
        colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
      )
    ];
  }

  List<charts.Series<Income, String>> incomesListDB() {
    return [
      new charts.Series<Income, String>(

          id: 'Sales',
          domainFn: (Income sales, _) => sales.name,
          measureFn: (Income sales, _) => sales.value ?? 0,
          data: _incomes)
    ];
  }

  List<charts.Series<RecurrentIncome, String>> recurrentIncomesListDB() {
    return [
      new charts.Series<RecurrentIncome, String>(
          id: 'Sales',

          domainFn: (RecurrentIncome sales, _) => sales.name,
          measureFn: (RecurrentIncome sales, _) => sales.value ?? 0,
          data: _recurrentIncomes)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          children: <Widget>[
            buildCardBalance(context),
            buildCardProgress(context),
            buildCardExpenses(context),
            buildCardRecurrentIncome(context),
            buildCardIncome(context),
            buildCardGoal(context),

          ],
        ),
      ),
      floatingActionButton: _renderSpeedDial(),
    );
  }

  Padding buildCardIncome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new GestureDetector(
        onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                  widget: IncomeHistoryPage(title: "Income History")),
            ).then((context) async {
              await loadIncome();
              calculateBalance();
            }),
        child: Card(
          child: Column(
            children: [
              Text("Incomes"),
              new Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                color: Colors.white,
                constraints: BoxConstraints.expand(width: 300.0, height: 300.0),
                child: _incomes.length > 0
                    ? PieOutsideLabelChart(incomesListDB())
                    : new Text("No Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildCardExpenses(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new GestureDetector(
        onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                widget: ExpensesHistoryPage(title: "Expenses history"),
              ),
            ).then((context) async {
              await loadExpenses();
              calculateBalance();
            }),
        child: Card(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 250.0, maxWidth: 200.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                new Container(
                  child: new Column(
                    children: [
                      new Text("Expenses:\n", style: TextStyle(fontSize: 20.0)),
                      new Text(
                          "Entertainment - 10%\nFood - 20%\nRent- 30%\nDrinks - 40%")
                    ],
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  constraints: BoxConstraints(maxWidth: 300.0),
                ),
                new Expanded(
                  child: new Container(
                    child: _expenses.length > 0
                        ? PieOutsideLabelChart(expensesListDB())
                        : new Text(
                            "no data",
                            style: TextStyle(fontSize: 20.0),
                          ),
                    constraints:
                        BoxConstraints(maxHeight: 180.0, maxWidth: 180.0),
                    alignment: Alignment.centerRight,
                  ),
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildCardRecurrentIncome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new GestureDetector(
        onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                  widget: RecurrentIncomeHistoryPage(title: "Income")),
            ).then((context) async {
              await loadRecurrentIncome();
              calculateBalance();
            }),
        child: Card(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 180.0, maxWidth: 180.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                new Container(
                  child: _recurrentIncomes.length > 0
                      ? HorizontalBarLabelChart(recurrentIncomesListDB())
                      : new Text(
                          "no data",
                          style: TextStyle(fontSize: 20.0),
                        ),
                  constraints:
                      BoxConstraints(maxHeight: 180.0, maxWidth: 180.0),
                  alignment: Alignment.centerLeft,
                ),
                new Expanded(
                  child: new Column(
                    children: [
                      new Text("Income:\n", style: TextStyle(fontSize: 20.0)),
                      new Text(
                          "Salary - 10%\nScholarship - 20%\nLottery- 30%\nOther - 40%")
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildCardProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new GestureDetector(
        child: Card(
          child: new Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 80.0, maxWidth: 180.0),
            alignment: Alignment.centerLeft,
            child: new Column(
              children: [
                new Text(
                  "How much you spent this month:\n",
                ),
                new Container(
                  child: new LinearProgressIndicator(
                    value: totalIncomes > totalExpenses
                        ? totalExpenses / totalIncomes
                        : 1.0,
                    backgroundColor: Colors.amber,
                    valueColor: null,
                  ),
                  padding: EdgeInsets.all(5.0),
                ),
                new Row(
                  children: [
                    new Expanded(
                      child: new Container(
                        child: Text(totalExpenses.toString()),
                        padding: EdgeInsets.all(5.0),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        child: Text(totalIncomes.toString()),
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildCardBalance(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Card(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 50.0, maxWidth: 180.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    child: Text(
                      "Balance",
                      textScaleFactor: 2.0,
                    ),
                    padding: EdgeInsets.all(5.0),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      currentBalance.toString(),
                      textScaleFactor: 2.0,
                      style: TextStyle(
                          color:
                              currentBalance > 0 ? Colors.green : Colors.red),
                    ),
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Padding buildCardGoal(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Card(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 50.0, maxWidth: 180.0),
            alignment: Alignment.centerLeft,
            child: new GestureDetector(
              onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => goalsPage()));
                        },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    child: Text(
                      "Your Goals",
                      textScaleFactor: 2.0,
                    ),
                    padding: EdgeInsets.all(5.0),
                  ),
                ),
                Expanded(
                  child: new Container(
                    child: Icon(Icons.assignment_turned_in),
                    padding: EdgeInsets.fromLTRB(5.0, 12.0, 12.0, 12.0),
                  ),
                ),
              ],
            ),
           ),
          ),
        ),
      ),
    );
}


class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  PieOutsideLabelChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.auto),
          ],
          startAngle: 0.5,
        ));
  }
}

class HorizontalBarLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  HorizontalBarLabelChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }
}
