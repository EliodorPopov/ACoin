import 'package:firstflut/Income.dart';
import 'package:firstflut/RecurrentIncome.dart';
import 'package:firstflut/buildExpensesHistoryPage.dart';
import 'package:firstflut/buildRecurrentIncomeHistoryPage.dart';
import 'package:firstflut/buildIncomeHistoryPage.dart';
import 'package:firstflut/buttonMenu.dart';
import 'package:firstflut/db_context.dart';
import 'package:firstflut/Expense.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Modal modal;
  DbContext _context;
  List<Expense> _expenses = new List<Expense>();
  List<Income> _incomes = new List<Income>();
  List<RecurrentIncome> _recurrentIncomes = new List<RecurrentIncome>();

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    modal = new Modal(
      onExpenseAdded: loadExpenses,
      onIncomeAdded: loadIncome,
      onRecurrentIncomeAdded: loadRecurrentIncome
    );
    loadRecurrentIncome();
    loadExpenses();
    loadIncome();
  }

  void loadExpenses() {
    _context.readExpense().then((list) {
      setState(() {
        _expenses = list;
      });
    });
  }

  void loadIncome() {
    _context.readIncome().then((list) {
      setState(() {
        _incomes = list;
      });
    });
  }

  void loadRecurrentIncome() {
    _context.readRecurrentIncome().then((list) {
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
          data: _expenses)
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
            buildCardProgress(context),
            buildCardExpenses(context),
            buildCardRecurrentIncome(context),
            buildCardIncome(context),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => modal.mainBottomSheet(context),
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding buildCardIncome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new InkWell(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      BuildIncomeHistoryPage(title: "Income History")),
            ),
        child: Card(
          child: Column(children: [
            Text("Incomes"),
            new Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              color: Colors.white,
              constraints: BoxConstraints.expand(width: 300.0, height: 300.0),
              child: _incomes.length >
                      0 //I've put here the spendings series instead of income just to show that it loads from db
                  ? PieOutsideLabelChart(
                      incomesListDB()) // but it seems that widget has some problems with rendering when the series is empty
                  : new Text("No Data"),
            ),
          ]),
        ),
      ),
    );
  }

  Padding buildCardExpenses(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new InkWell(
        onDoubleTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) =>
                    new BuildExpensesHistoryPage(title: "Expenses history"))),
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
                      new Text("Expenses:\n",
                          style: TextStyle(fontSize: 20.0)),
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
                    child: _expenses.length >
                            0 //I've put here the spendings series instead of income just to show that it loads from db
                        ? PieOutsideLabelChart(
                            expensesListDB()) // but it seems that widget has some problems with rendering when the series is empty
                        : new Text("...loading"),
                    constraints:
                        BoxConstraints(maxHeight: 180.0, maxWidth: 180.0),
                    alignment: Alignment.centerRight,
                  ),
                  flex: 3,
                ),
              ],
              //mainAxisAlignment: MainAxisAlignment.end,
            ),
            //alignment: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  Padding buildCardRecurrentIncome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new InkWell(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      BuildRecurrentIncomeHistoryPage(title: "Income")),
            ),
        child: Card(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                color: Colors.white,
                constraints: BoxConstraints(maxHeight: 180.0, maxWidth: 180.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    new Container(
                      child: _recurrentIncomes.length >
                              0 //I've put here the spendings series instead of income just to show that it loads from db
                          ? HorizontalBarLabelChart(
                              recurrentIncomesListDB()) // but it seems that widget has some problems with rendering when the series is empty
                          : new Text(
                              "...loading"), //so instead of rendering empty chart replace it with placeholder while data is loaded
                      constraints:
                          BoxConstraints(maxHeight: 180.0, maxWidth: 180.0),
                      alignment: Alignment.centerLeft,
                    ),
                    new Expanded(
                      child: new Column(
                        children: [
                          new Text("Income:\n",
                              style: TextStyle(fontSize: 20.0)),
                          new Text(
                              "Salary - 10%\nScholarship - 20%\nLottery- 30%\nOther - 40%")
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    )
                  ],
                  //mainAxisAlignment: MainAxisAlignment.start,
                ))),
      ),
    );
  }

  Padding buildCardProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Card(
        child: new Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          color: Colors.white,
          constraints: BoxConstraints(maxHeight: 80.0, maxWidth: 180.0),
          alignment: Alignment.centerLeft,
          child: new Column(children: [
            new Text(
              "How much you spent this month:\n",
            ),
            new Container(
              child: new LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.amber,
                valueColor: null,
              ),
              padding: EdgeInsets.all(5.0),
            ),
            new Row(
              children: [
                new Expanded(
                  child: new Container(
                    child: Text("1400 lei"),
                    padding: EdgeInsets.all(5.0),
                  ),
                ),
                new Expanded(
                  child: new Container(
                    child: Text("2000 lei"),
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

/// Sample linear data type.
class LinearSales {
  final String type;
  final int percent;

  LinearSales(this.type, this.percent);
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
          startAngle: 1 / 5 * 3.1415,
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
      // Hide domain axis.
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }
}
