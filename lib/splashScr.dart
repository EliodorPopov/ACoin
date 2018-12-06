import 'package:acoin/myApp.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScr extends StatefulWidget {
  @override
  _SplashScrState createState() => new _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 1,
        navigateAfterSeconds: new MyApp(),
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
