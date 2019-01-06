import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/screens/govidhyanapp.dart';


class SignoutScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SignoutWidget();
  }
}
class SignoutWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignoutState();
  }
}

class SignoutState extends State<SignoutWidget> with TickerProviderStateMixin<SignoutWidget> {
  @override
  Widget build(BuildContext context) {
    showAppDialog(context);
    return Container(
    );
  }

}

void showAppDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Signout Warning"),
        content: new Text("You Sure want to signout?"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Yes"),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
              HomeScreen screen=HomeScreen();
              screen.signedUp=false;
              return screen;
            }));}
          ),
        ],
      );
    },
  );
}