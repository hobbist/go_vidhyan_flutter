import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/screens/govidhyanapp.dart';
class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return LoginWidget();
  }
}

class LoginWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}


class LoginState extends State<LoginWidget>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool singup=false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return
       Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key:this._formKey,
        child: ListView(children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: username
          ),
        ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: password
            ),
          ),
          Container(
            width: screenSize.width,
            child: Column(
              children: <Widget>[RaisedButton(
                child: Text(
                  submit,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
              HomeScreen screen=HomeScreen();
              screen.signedUp=true;
              return screen;
              }));
              },
                color: Colors.lightGreen,
              ),
              ],
            ),
            margin: EdgeInsets.only(top: 20.0),
          )
      ],),
      ),
       );
  }
}

