import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firstflut/buttonMenu.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key key, this.title}) : super(key: key);
  final String title;
  Modal modal = new Modal();

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
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new ListView(
          children: <Widget>[
            buildCard(context),
            buildCard(context),
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
        child: Text("spendings"),
      ),
    );
  }

  
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 150));
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PieOutsideLabelChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,

        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.auto),
          ],
          startAngle: 1 / 5 * 3.1415,
        ));
  }
}
