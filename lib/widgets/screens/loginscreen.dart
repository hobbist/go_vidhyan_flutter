import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: login,
        home: Center(child: Text(login)),
    );
  }
}