import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/utils/functions.dart';
import 'package:govidhyan_flutter/widgets/screens/loginscreen.dart';
class GoVidhyanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:HomeScreen(),
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          primaryTextTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'))),
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget{
  final drawerItems = [ new DrawerItem(login, Icons.alternate_email),];
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen>{
  int _selectedDrawerIndex = 1;

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 1:
        return new LoginScreen();
      default:
        return new Text("Error Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    drawerOptions.add(DrawerHeader(
      decoration: BoxDecoration(
          image: DecorationImage(image: ExactAssetImage(imageLogoPath)),
          color: Colors.lightGreen
      ),
    ));
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      i=i+1;
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.language),
      title: new Text(aboutUs),
      onTap: () => launchURL(goVidhnyanUrl),
    ));

    return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: drawerOptions,
          ),
        ),

      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

}
