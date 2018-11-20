import 'package:firstflut/db_context.dart';
import 'package:flutter/material.dart';

class PopupCreateCategory {
  static Future<String> createCategory2(context) async {
    final formKey = GlobalKey<FormState>();
    String _addedCategory = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Category"),
          content: Column(children: [
            Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Name:'),
                onSaved: (input) {
                  //_newCategory = input;
                  _addedCategory = input;
                  print(input);
                },
                validator: (input) => input.isEmpty ? 'enter value' : null,
                onFieldSubmitted: (e) {
                  //_newCategory = e;
                  print(e);
                },
              ),
            ),
            RaisedButton(
              child: Text("Add"),
              onPressed: () {
                // print(_newCategory);
                // _categories.removeLast();
                // _categories.add(_newCategory);
                // _categories.add("Add Category");
                // _newCategory = null;
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  if (_addedCategory != "") {
                    Navigator.pop(context);
                  }
                  return _addedCategory;
                  //return _addedCategory;
                  //Navigator.pop(context);
                  //return _addedCategory;
                  //Navigator.pop(context);
                  print("printed");
                }

                //setState(() {});
              },
            ),
          ]),
        );
      },
    );

    if (_addedCategory != "") return  _addedCategory; else return "nothing";
  }
}
