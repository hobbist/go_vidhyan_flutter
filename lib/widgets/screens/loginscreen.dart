import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Flexible(child: TextField(
            decoration: InputDecoration.collapsed(border:InputBorder.none,
                hintText: 'Full Name e.g \'Narayan Jatkar\''),
            autofocus: bool.fromEnvironment('true'),))
        ],
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        )
      ],

    );
  }
}

