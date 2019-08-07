import 'package:acoin/DebtPage.dart';
import 'package:acoin/category.dart';
import 'package:acoin/data/database_helper.dart';
import 'package:acoin/expense.dart';
import 'package:acoin/income.dart';
import 'package:acoin/loginPage.dart';
import 'package:acoin/recurrentIncome.dart';
import 'package:acoin/addExpensePage.dart';
import 'package:acoin/addIncomePage.dart';
import 'package:acoin/expensesHistoryPage.dart';
import 'package:acoin/incomeHistoryPage.dart';
import 'package:acoin/recurrentIncomeHistoryPage.dart';
import 'package:acoin/db_context.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flutter/cupertino.dart';
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
  DatabaseHelper _db;
  ScrollController _scrollController;
  bool _dialVisible = true;
  DbContext _context;
  String _period = 'Today';
  List<Expense> _expenses = new List<Expense>();
  List<Income> _incomes = new List<Income>();
  List<Category> _categoryTableList = new List<Category>();
  List<Category> _categories = new List<Category>();
  List<int> _categoryList = new List<int>();
  Category tempCat = new Category();
  int tempTot = 0;
  List<RecurrentIncome> _recurrentIncomesTemp = new List<RecurrentIncome>();
  List<RecurrentIncome> _recurrentIncomes = new List<RecurrentIncome>();
  int currentBalance = 0;
  int totalIncomes = 0;
  int totalExpenses = 0;

  void _showSuccessSnackBar() {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: 'Information submitted!',
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.green,
        ),
        isDismissible: false,
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.green)
      ..show(context);
  }

  _addRecurrentIncome(BuildContext context) {
    var route = MaterialPageRoute(
        builder: (c) =>
            AddIncomePage(title: "Add Recurrent Income", isRecurrent: true));
    Navigator.push(context, route).then((isSuccessful) async {
      if (isSuccessful) {
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
        calculateBalance();
        _showSuccessSnackBar();
      }
    });
  }

  _addExpense(BuildContext context) {
    var route =
        MaterialPageRoute(builder: (c) => AddExpensePage(title: "Add Expense"));
    Navigator.push(context, route).then((isSuccessful) {
      if (isSuccessful == true) {
        calculateBalance();
        _showSuccessSnackBar();
      }
    });
  }

  @override
  initState() {
    super.initState();
    _db = new DatabaseHelper();
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
    calculateCategories();
  }

  void calculateCategories() async {
    _categories.clear();

    _categoryList.forEach((c) {
      tempCat = new Category();
      tempCat.id = c;
      tempCat.total = _expenses.fold(
          0, (val, e) => val + (e.categoryId == c ? e.value : 0));
      _categories.add(tempCat);
    });

    _categories.forEach((c) {
      _expenses.forEach((e) {
        if (e.categoryId == c.id) {
          c.path = e.categoryIconPath;
          c.name = e.categoryName;
        }
      });
    });
    setState(() {
      _categories = _categories.toList();
    });
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
      onOpen: () {
        print('OPENING DIAL');
      },
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
    return _context.readExpense(_period).then((list) {
      setState(() {
        _expenses = list;
        _categoryList =
            list.map((e) => e.categoryId).toSet().toList(growable: true);
      });
    });
  }

  Future<Null> loadIncome() {
    return _context.readIncome(_period).then((list) {
      setState(() {
        _incomes = list;
        _incomes.sort((a, b) => b.date.millisecondsSinceEpoch
            .compareTo(a.date.millisecondsSinceEpoch));
      });
    });
  }

  Future<Null> loadRecurrentIncome() {
    return _context.readRecurrentIncome('All time').then((list) {
      setState(() {
        _recurrentIncomesTemp = list;
        _recurrentIncomes.clear();
        _recurrentIncomesTemp.forEach((i) {
          print(i.name + ' ' + i.isEnabled.toString());
          if (i.isEnabled) _recurrentIncomes.add(i);
        });
      });
    });
  }

  List<charts.Series<Category, String>> expensesListDB() {
    return [
      new charts.Series<Category, String>(
        id: 'Sales',
        domainFn: (Category sales, _) => sales.name,
        measureFn: (Category sales, _) => sales.total ?? 0,
        //colorFn: (c, e) => charts.MaterialPalette.blue.shadeDefault,
        data: _categories,
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
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          data: _recurrentIncomes)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Theme(
          child: new Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Title(
                    child: Text(widget.title),
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<String>(
                    value: _period,
                    items: <DropdownMenuItem<String>>[
                      new DropdownMenuItem(
                        child: new Text('Today'),
                        value: 'Today',
                      ),
                      new DropdownMenuItem(
                          child: new Text('This week'), value: 'This week'),
                      new DropdownMenuItem(
                          child: new Text('This month'), value: 'This month'),
                      new DropdownMenuItem(
                          child: new Text('Last month'), value: 'Last month'),
                      new DropdownMenuItem(
                          child: new Text('This year'), value: 'This year'),
                      new DropdownMenuItem(
                          child: new Text('All time'), value: 'All time'),
                    ],
                    onChanged: (String value) {
                      _period = value;
                      setState(() {
                        calculateBalance();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          data: new ThemeData.dark(),
        ),
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
            buildCardDebt(context),
            new Padding(
                padding: EdgeInsets.all(3.0),
                child: new Card(
                    child: new FlatButton(
                        child: new Text('Log out'),
                        onPressed: () {
                          _db.deleteUsers();
                          Navigator.pushReplacement(
                              context, SlideLeftRoute(widget: LoginPage()));
                        })))
          ],
        ),
      ),
      floatingActionButton: _renderSpeedDial(),
    );
  }

  Padding buildCardIncome(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          shape: BeveledRectangleBorder(),
          child: GestureDetector(
            onTap: () => Navigator.push(
                  context,
                  SlideLeftRoute(
                      widget: IncomeHistoryPage(title: "Income History")),
                ).then((context) async {
                  calculateBalance();
                }),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(7.0),
                    child: new Text("Last incomes",
                        style: TextStyle(fontSize: 20.0))),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  color: Colors.white,
                  constraints: BoxConstraints(
                      maxHeight: _incomes.length > 5
                          ? 5 * 60.0
                          : _incomes.length * 48.0,
                      maxWidth: 400.0),
                  child: new ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _incomes.length > 5 ? 5 : _incomes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.blue[200],
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                    child: Image.asset(
                                        _incomes.elementAt(index).sourcePath),
                                    height: 30.0),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      _incomes.elementAt(index).name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Text(
                                      "+${_incomes.elementAt(index).value.toString()} MDL",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Padding buildCardExpenses(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: new GestureDetector(
        onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                widget: ExpensesHistoryPage(title: "Expenses"),
              ),
            ).then((context) {
              calculateBalance();
            }),
        child: Card(
          shape: BeveledRectangleBorder(),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 180.0, maxWidth: 200.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  child: new Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: new Text(
                            "Expenses",
                            textScaleFactor: 1.5,
                          )),
                      new Container(
                        child: new ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              _categories.length > 5 ? 5 : _categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(bottom: 2.0),
                                    child: Image.asset(_categories[index].path),
                                    height: 30.0),
                                Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  width: 100.0,
                                  child: Text(
                                    _categories[index].total.toString() +
                                        ' lei',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        constraints:
                            BoxConstraints(maxHeight: 120.0, maxWidth: 130.0),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  constraints:
                      BoxConstraints(maxHeight: 180.0, maxWidth: 130.0),
                  alignment: Alignment.topLeft,
                ),
                new Expanded(
                  child: new Container(
                    padding: EdgeInsets.all(0.0),
                    child: _categories.length > 0
                        ? PieOutsideLabelChart(expensesListDB())
                        : new Text(
                            "no data",
                            style: TextStyle(fontSize: 20.0),
                          ),
                    constraints:
                        BoxConstraints(maxHeight: 180.0, maxWidth: 160.0),
                    alignment: Alignment.centerRight,
                  ),
                  flex: 2,
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
      padding: const EdgeInsets.all(3.0),
      child: new GestureDetector(
        onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                  widget: RecurrentIncomeHistoryPage(title: "Income")),
            ).then((context) {
              calculateBalance();
            }),
        child: Card(
          shape: BeveledRectangleBorder(),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: 180.0, maxWidth: 200.0),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                new Container(
                  child: new Text(
                    'Monthly Income',
                    textScaleFactor: 1.5,
                  ),
                  alignment: Alignment.center,
                ),
                new Expanded(
                  child: _recurrentIncomes.length > 0
                      ? HorizontalBarLabelChart(recurrentIncomesListDB())
                      : new Text(
                          "no data",
                          style: TextStyle(fontSize: 20.0),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildCardProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: new GestureDetector(
        child: Card(
          shape: BeveledRectangleBorder(),
          child: new Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: new Column(
              children: [
                new Text(
                  "How much you spent\n",
                  textScaleFactor: 1.3,
                ),
                new Container(
                  child: new LinearProgressIndicator(
                    value: totalIncomes > totalExpenses
                        ? totalExpenses / totalIncomes
                        : 1.0,
                    backgroundColor: Colors.indigo[100],
                    valueColor: null,
                  ),
                  padding: EdgeInsets.all(5.0),
                ),
                new Row(
                  children: [
                    new Expanded(
                      child: new Container(
                        child: Text(totalExpenses.toString() + " lei"),
                        padding: EdgeInsets.all(5.0),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        child: Text((totalIncomes > 0
                                    ? (totalExpenses / totalIncomes) * 100
                                    : 0)
                                .toStringAsFixed(0) +
                            "%"),
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        child: Text(totalIncomes.toString() + " lei"),
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
      padding: EdgeInsets.all(3.0),
      child: GestureDetector(
        child: Card(
          shape: BeveledRectangleBorder(),
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
    padding: EdgeInsets.all(3.0),
    child: GestureDetector(
      child: Card(
        shape: BeveledRectangleBorder(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          color: Colors.white,
          constraints: BoxConstraints(maxHeight: 50.0, maxWidth: 180.0),
          alignment: Alignment.centerLeft,
          child: new GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoalsPage()));
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

Padding buildCardDebt(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(10.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DebtPage()));
      },
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
                    "Your Debts",
                    textScaleFactor: 2.0,
                  ),
                  padding: EdgeInsets.all(5.0),
                ),
              ),
              Expanded(
                child: new Container(
                  child: Icon(Icons.assignment_late),
                  padding: EdgeInsets.fromLTRB(5.0, 12.0, 12.0, 12.0),
                ),
              ),
            ],
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
