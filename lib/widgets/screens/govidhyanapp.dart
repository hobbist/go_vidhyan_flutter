import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/utils/functions.dart';
import 'package:govidhyan_flutter/widgets/screens/loginscreen.dart';
class GoVidhyanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<StatefulWidget>{
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title:title,
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(image: ExactAssetImage(imageLogoPath)),
                    color: Colors.lightGreen
                ),
              ),
              ListTile(
                title: Text(login,style: TextStyle(fontSize: 17)),
                onTap: () {

                },
              ),
              ListTile(
                title: Text(profile,style: TextStyle(fontSize: 17),),
                onTap: () {

                },
              ),
              ListTile(
                title: Text(stages,style: TextStyle(fontSize: 17)),
                onTap: () {

                },
              ),
              ListTile(
                title: Text(contact_coordinator,style: TextStyle(fontSize: 17)),
                onTap: () {

                },
              ),ListTile(
                title: Text(aboutUs,style: TextStyle(fontSize: 17)),
                onTap: () {
                  launchURL(goVidhnyanUrl);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(title: Text(title),),
      ),
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          primaryTextTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'))),
    );;
  }

}
