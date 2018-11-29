import 'package:firstflut/dashboard.dart';
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
<<<<<<< HEAD:lib/splashScr.dart
        seconds: 1,
        navigateAfterSeconds: new MyApp(),
        title: new Text(
          'Welcome to ACoin',
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
        ),
        image: new Image.network('https://i.imgur.com/0vfdi3O.png'),
        backgroundColor: Colors.indigo,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.white);
=======
      seconds: 2,
      navigateAfterSeconds: new MyApp(),
      title: new Text('Welcome to ACoin',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
        color: Colors.white
      ),),
      image:  new Image( image: AssetImage('graphics/AcoinLogo.png')),
      backgroundColor: Colors.indigo,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.white
    );
>>>>>>> bdd7ee0e1a500704cbf1ba906a8c7bccfa2ec203:lib/SplashScr.dart
  }
}

// TODO move to separate file
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Eliodor',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
        //fontFamily: 'Pacifico',
      ),
      home: new Dashboard(title: 'Dashboard'),
    );
  }
}
