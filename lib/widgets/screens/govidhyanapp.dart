import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/screens/splashscreen.dart';
class GoVidhyanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:SplashScreen(),
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          primaryTextTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'))),
    );
  }
}
