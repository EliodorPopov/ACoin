import 'package:firstflut/expense.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firstflut/buttonMenu.dart';
import './buildExpensesHistoryPage.dart';
import './buildIncomeHistoryPage.dart';
import './db_context.dart';


class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardState createState() =>
      new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Modal modal = new Modal();
  DbContext _context;
  List<Expense> _expenses = new List<Expense>();

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readExpense().then((list) {
      setState(() {
        _expenses = list;
      });
    });
  }

  List<charts.Series<LinearSales, String>> spendingsData() {
    final data = [
      new LinearSales('Rent', 25),
      new LinearSales('Food', 50),
      new LinearSales('Entertainment', 70),
      new LinearSales('Drinks', 25),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.type,
        measureFn: (LinearSales sales, _) => sales.percent,
        data: data,
      )
    ];
  }

  List<charts.Series<Expense, String>> spendingsDataDB() {
    // final data = [
    //   new LinearSales('Rent', 25),
    //   new LinearSales('Food', 50),
    //   new LinearSales('Entertainment', 70),
    //   new LinearSales('Drinks', 25),
    // ];

    var data = [];
    for (int i = 0; i < _expenses.length; i++) {
      data.add(new Expense(_expenses[i].name, _expenses[i].value));
    }

    return [
      new charts.Series<Expense, String>(
        id: 'Sales',
        domainFn: (Expense sales, _) => sales.name,
        measureFn: (Expense sales, _) => sales.value,
        data: data,
      )
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
            buildCardSpendings(context),
            buildCardEarnings(context),
            buildCard(context),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => modal.mainBottomSheet(context),
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding buildCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new InkWell(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => buildSpendingsPage()),
            ),
        child: Card(
          child: Column(children: [
            Text("Spendings"),
            new Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              color: Colors.white,
              constraints: BoxConstraints.expand(width: 300.0, height: 300.0),
              child: PieOutsideLabelChart(spendingsData()),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildSpendingsPage() {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Spendings"),
      ),
      body: new Center(
        child: Text("Here you will see your transaction history"),
      ),
    );
  }

  Padding buildCardSpendings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new InkWell(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      new BuildExpensesHistoryPage(title: "Spendings history")),
            ),
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
                      new Text("Spendings:\n",
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
                    child: PieOutsideLabelChart(spendingsData()),
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

  Padding buildCardEarnings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new InkWell(
        onDoubleTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => BuildIncomeHistoryPage(title: "Income")),
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
                      child: HorizontalBarLabelChart(spendingsData()),
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
