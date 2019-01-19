import 'dart:async';
import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/screens/homescreen.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';



class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _SplashScreenState();
  }

}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _iconAnimationController=null;
  var _iconAnimation=null;


  void handleTimeout() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) {
          HomeScreen screen= new HomeScreen();
          screen.signedUp=false;
          return screen;
        }));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();

    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Scaffold(backgroundColor: Colors.lightGreen,
        body: new Center(
            child: new Image(
              image: new AssetImage(imageLogoPath),
              width: _iconAnimation.value * 100,
              height: _iconAnimation.value * 100,
            )),
      ),
    );
  }
}