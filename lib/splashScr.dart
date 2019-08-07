import 'package:acoin/dashboard.dart';
import 'package:acoin/data/database_helper.dart';
import 'package:acoin/loginPage.dart';
import 'package:acoin/myApp.dart';
import 'package:acoin/slide_left_transition.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScr extends StatefulWidget {
  @override
  _SplashScrState createState() => new _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  DatabaseHelper _db = new DatabaseHelper();
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    _db.isLoggedIn().then((res) {
       res
          ? Navigator.of(context).pushReplacement(SlideLeftRoute(widget: MyApp()))
           : Navigator.of(context).pushReplacement(SlideLeftRoute(widget: LoginPage()));
      isLoggedIn = res;
      print(res);
    });
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: null,
        title: new Text(
          'Welcome to ACoin',
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
        ),
        image: new Image(image: AssetImage('images/wallet.png')),
        backgroundColor: Colors.indigo,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.white);
  }
}
