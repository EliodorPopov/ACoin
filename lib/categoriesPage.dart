import 'package:acoin/addCategoryPage.dart';
import 'package:acoin/category.dart';
import 'package:acoin/db_context.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => new _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  DbContext _context;
  List<Category> categories = new List<Category>();

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    _context.readCategories().then((list) {
      setState(() {
        categories = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Categories"),
      ),
      body: new GridView.builder(
          itemCount: categories.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: () =>
                  addCategory(true, categories.toList().elementAt(index)),
              onTap: () => selectCategory(categories.toList().elementAt(index)),
              child: Card(
                elevation: 3.0,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: new FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Image(
                          image: AssetImage(
                              categories.toList().elementAt(index).path),
                        ),
                      ),
                    ),
                    Text(
                      categories.toList().elementAt(index).name,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => addCategory(false, null),
      ),
    );
  }

  void selectCategory(Category cat) {
    Navigator.pop(context, {'name': cat.name, 'path': cat.path});
  }

  void addCategory(bool editPage, Category currentCategory) async {
    var route = MaterialPageRoute(
      builder: (context) => AddCategoryPage(
          currentCategory: currentCategory,
          editPage: editPage,
          categories: categories),
    );
    final response = await Navigator.push(context, route);
    if (response.toString() != 'null') {
      print(response.toString());
      await _context.readCategories().then((list) {
        setState(() {
          categories = list;
        });
      });
      _showSuccessSnackBar(response ? "Saved" : "Deleted", response);
    }
  }

  void _showSuccessSnackBar(String message, bool color) {
    Flushbar(flushbarPosition: FlushbarPosition.TOP)
      ..message = message
      ..icon = Icon(
        Icons.done,
        size: 28.0,
        color: color ? Colors.green : Colors.red,
      )
      ..duration = Duration(seconds: 2)
      ..leftBarIndicatorColor = color ? Colors.green : Colors.red
      ..show(context);
  }
}
