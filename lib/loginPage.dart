import 'package:acoin/data/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:acoin/myApp.dart';
import 'package:acoin/data/rest_ds.dart';
import 'package:flushbar/flushbar.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final api = new RestDatasource();
  String _email;
  String _password;
  // DatabaseHelper _db = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('images/power.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'email',
      validator: (input) =>
          input.isEmpty || !input.contains('@') || !input.contains('.')
              ? "Please enter a valid email"
              : null,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (value) {
        _email = value;
      },
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: 'qwertyuiop',
      obscureText: true,
      validator: (input) {
        if (input.isEmpty) return "Please enter a password";
        if (input.length < 5) return "Minimium length: 5";
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (value) {
        _password = value;
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () => _submit(),
        // {
        //   final api = new RestDatasource();
        //   var x;
        //   api.login(_email, _password).then((onValue) {
        //     print(onValue);
        //     x = onValue;
        //   }).whenComplete(() {
        //     Navigator.push(context, MaterialPageRoute(builder: (c) => MyApp()));
        //     print(x);
        //   });
        // },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              forgotLabel
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      var res = await api.login(_email, _password);
      if(res != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MyApp()));
      } else {
        _showFailedSnackBar('Login failed');
      }
    }
  }

  void _showFailedSnackBar(String message) {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: message,
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.red
        ),  
        isDismissible: false,
        duration: Duration(seconds: 2),
        leftBarIndicatorColor: Colors.red)
      ..show(context);
  }
}
