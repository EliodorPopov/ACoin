import 'package:flutter/material.dart';

class CategoriesIconsPage extends StatefulWidget {
  CategoriesIconsPage({Key key}) : super(key: key);

  @override
  _CategoriesIconsPageState createState() => new _CategoriesIconsPageState();
}

class _CategoriesIconsPageState extends State<CategoriesIconsPage> {
  List<String> iconList = new List<String>();

  @override
  initState() {
    super.initState();
    try {
      iconList.add('images/power.png');
      iconList.add('images/icons/airplane.png');
      iconList.add('images/icons/bank.png');
      iconList.add('images/icons/beacon.png');
      iconList.add('images/icons/beats.png');
      iconList.add('images/icons/bell.png');
      iconList.add('images/icons/bicycle.png');
      iconList.add('images/icons/box.png');
      iconList.add('images/icons/browser.png');
      iconList.add('images/icons/bulb.png');
      iconList.add('images/icons/casino.png');
      iconList.add('images/icons/chair.png');
      iconList.add('images/icons/config.png');
      iconList.add('images/icons/cup.png');
      iconList.add('images/icons/folder.png');
      iconList.add('images/icons/football.png');
      iconList.add('images/icons/headphones.png');
      iconList.add('images/icons/heart.png');
      iconList.add('images/icons/laptop.png');
      iconList.add('images/icons/letter.png');
      iconList.add('images/icons/like.png');
      iconList.add('images/icons/map.png');
      iconList.add('images/icons/medal.png');
      iconList.add('images/icons/mic.png');
      iconList.add('images/icons/milk.png');
      iconList.add('images/icons/pencil.png');
      iconList.add('images/icons/picture.png');
      iconList.add('images/icons/polaroid.png');
      iconList.add('images/icons/printer.png');
      iconList.add('images/icons/search.png');
      iconList.add('images/icons/shopping-bag.png');
      iconList.add('images/icons/speed.png');
      iconList.add('images/icons/stopwatch.png');
      iconList.add('images/icons/tactics.png');
      iconList.add('images/icons/tweet.png');
      iconList.add('images/icons/watch.png');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Select Icon"),
      ),
      body: new GridView.builder(
        itemCount: iconList.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, iconList.toList().elementAt(index));
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Image(
                  image: AssetImage(iconList.toList().elementAt(index)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
