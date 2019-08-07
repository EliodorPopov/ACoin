import 'package:acoin/Pages/Category/addCategoryPage.dart';
import 'package:acoin/Models/category.dart';
import 'package:acoin/utils/db_context.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key key, this.categoryStatus}) : super(key: key);
  final int categoryStatus;

  @override
  _CategoriesPageState createState() => new _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  DbContext _context;
  int categoryStatus;
  List<Category> categories = new List<Category>();

  @override
  initState() {
    super.initState();
    _context = new DbContext();
    categoryStatus = widget.categoryStatus;
    _context.readCategories(widget.categoryStatus).then((list) {
      setState(() {
        categories = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(categoryStatus == 1 ? "Categories" : "Sources"),
      ),
      body: new GridView.builder(
          itemCount: categories.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: () => addCategory(
                  categories.toList().elementAt(index),
                  categories.toList().elementAt(index).categoryStatus),
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
        onPressed: () => addCategory(null, categoryStatus),
      ),
    );
  }

  void selectCategory(Category cat) {
    Navigator.pop(context, {'name': cat.name, 'path': cat.path, 'id': cat.id});
  }

  void addCategory(Category currentCategory, int categoryStatus) async {
    var route = MaterialPageRoute(
      builder: (context) => AddCategoryPage(
          currentCategory: currentCategory,
          categoryStatus: categoryStatus,
          categories: categories),
    );
    final response = await Navigator.push(context, route);
    if (response.toString() != 'null') {
      print(response.toString());
      await _context.readCategories(widget.categoryStatus).then((list) {
        setState(() {
          categories = list;
        });
      });
      _showSuccessSnackBar(response ? "Saved" : "Deleted", response);
    }
  }

  void _showSuccessSnackBar(String message, bool color) {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: message,
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: color ? Colors.green : Colors.red,
        ),
        isDismissible: false,
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: color ? Colors.green : Colors.red)
      ..show(context);
  }
}
