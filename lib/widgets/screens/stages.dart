import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/utils/functions.dart';


class StagesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StagesWidget();
  }

}

class StagesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StagesState();
  }
}

class StagesState extends State<StagesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
    child: Center(child: Image(image: AssetImage(comingSoonImage)
    ),)


    );
  }
}