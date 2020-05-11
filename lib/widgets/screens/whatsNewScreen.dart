import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
class WhatsNewScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return WhatsNewScreenState();
  }
}

class WhatsNewScreenState extends State<WhatsNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child:Center(child: Text(rules),));
  }


}