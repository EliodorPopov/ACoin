import 'package:acoin/categoriesIconsPage.dart';
import 'package:acoin/category.dart';
import 'package:acoin/db_context.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AddCategoryPage extends StatefulWidget {
  AddCategoryPage(
      {Key key, this.editPage, this.currentCategory, this.categories})
      : super(key: key);
  final bool editPage;
  final Category currentCategory;
  final List<Category> categories;

  @override
  _AddCategoryPageState createState() => new _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final formKey = GlobalKey<FormState>();
  String _name, _path;
  DbContext _context;
  bool nameExists = false;

  initState() {
    super.initState();
    _context = new DbContext();
    if (widget.editPage) {
      _path = widget.currentCategory.path;
      _name = widget.currentCategory.name;
    } else {
      _path = 'images/noimage.png';
      _name = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name:'),
                initialValue: _name,
                onSaved: (input) {
                  _name = input;
                },
                validator: (input) {
                  nameExists = false;
                  for (var c in widget.categories) {
                    if (_name == c.name &&
                        _name != widget.currentCategory.name) {
                      nameExists = true;
                      break;
                    }
                  }
                  if (input.length == 0) {
                    return 'Add a value';
                  }
                  if (nameExists) return 'Category exists';
                },
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Icon',
                      textScaleFactor: 1.8,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      constraints:
                          BoxConstraints.expand(width: 100.0, height: 100.0),
                      child: Image.asset(_path)),
                  //Text(_path == '' ? 'not seleted' : _path),
                  RaisedButton(
                    color: Colors.indigo[500],
                    onPressed: () {
                      selectIcon();
                    },
                    child: Text(
                      'Select',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  buildDeleteButton()
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.done),
        backgroundColor: Colors.green,
        onPressed: () => _submit(),
      ),
    );
  }

  void selectIcon() async {
    var route = MaterialPageRoute(builder: (context) => CategoriesIconsPage());
    final path = await Navigator.push(context, route);
    _path = path.toString();
    if (_path == 'null') _path = 'images/noimage.png';
    print(_path + ' yay');
  }

  void _submit() {
    if (_path == 'images/noimage.png')
      _showSnackBar('Please select an icon');
    else if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (widget.editPage) {
        if (widget.currentCategory.name != _name ||
            widget.currentCategory.path != _path)
          _context.editCategory(widget.currentCategory.id, _name, _path);
        Navigator.pop(context, true);
      } else {
        _context.addCategory(_name, _path);
        Navigator.pop(context, true);
      }
    }
  }

  Widget buildDeleteButton() {
    if (widget.editPage) {
      return new Padding(
        padding: EdgeInsets.all(20.0),
        child: RaisedButton(
          color: Colors.red,
          onPressed: () {
            _context.deleteCategory(widget.currentCategory.id);
            Navigator.pop(context, false);
          },
          child: Text(
            'Delete category',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else
      return Text('');
  }

  void _showSnackBar(String message) {
    Flushbar(flushbarPosition: FlushbarPosition.TOP)
      ..message = message
      ..icon = Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red,
      )
      ..duration = Duration(seconds: 3)
      ..leftBarIndicatorColor = Colors.red
      ..show(context);
  }
}
