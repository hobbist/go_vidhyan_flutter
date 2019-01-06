import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/utils/functions.dart';
import 'package:govidhyan_flutter/widgets/screens/loginscreen.dart';
import 'package:govidhyan_flutter/widgets/screens/signupscreen.dart';
import 'package:govidhyan_flutter/widgets/screens/stages.dart';
import 'package:govidhyan_flutter/widgets/screens/signoutDialog.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart';
import 'package:advanced_share/advanced_share.dart';
import 'dart:async';
import 'package:flutter/services.dart';

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
  Widget page;
  bool dialog=false;
  DrawerItem(this.title, this.icon,this.page);
  DrawerItem.empty(this.title, this.icon);
  DrawerItem.dialog(this.title, this.icon,this.dialog);
}

class HomeScreen extends StatefulWidget{
  static final HomeScreen _home=HomeScreen._internal();
  HomeScreen._internal();
  factory HomeScreen(){
      return _home;
  }

   bool _singedUp=false;
   void set signedUp(bool up){
     this._singedUp=up;
   }

  bool get signedUp{
    return this._singedUp;
  }

   final _drawerItems = [new DrawerItem(login, Icons.alternate_email,LoginScreen()),new DrawerItem(signup, Icons.accessibility,SignupScreen())];
   final _homeDrawerItems = [new DrawerItem(stages, Icons.assessment,StagesScreen()),new DrawerItem.empty(profile, Icons.account_box),
                              new DrawerItem.empty(whatsNew,Icons.flare),new DrawerItem.empty(contact_coordinator, Icons.perm_phone_msg),
                              ];
   
   List<DrawerItem> getHomedrawer()
  {
    return _singedUp==true?_homeDrawerItems:_drawerItems;
  }
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState(this.signedUp);
  }
}

class HomeScreenState extends State<HomeScreen>{
  bool _signedUp=false;
  HomeScreenState(this._signedUp);
  DrawerItem _selectedDrawerIndex = HomeScreen().getHomedrawer().elementAt(0) as DrawerItem;
  _onSelectItem(DrawerItem index) {
    print(index.title);
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _getDrawerItemWidget(BuildContext context,DrawerItem pos) {
    //TODO --needs work in case of logout dialog
      if(pos.dialog){
        showAppDialog(context);
      }
      else{
        return pos.page;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: buildDrawerOptions(),
          ),
        ),
      body: _getDrawerItemWidget(context,_selectedDrawerIndex),
    );
  }

  List<Widget> buildDrawerOptions(){
    var drawer=HomeScreen().getHomedrawer();
    var drawerOptions = <Widget>[];
    drawerOptions.add(DrawerHeader(
      decoration: BoxDecoration(
          image: DecorationImage(image: ExactAssetImage(imageLogoPath)),
          color: Colors.lightGreen
      ),
    ));
    int i=0;
    while(i<drawer.length){
      int index=i;
      var d = drawer[index];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: index == _selectedDrawerIndex,
            onTap: () => _onSelectItem(d),
          )
      );
      i=i+1;
    }
    if(this._signedUp){
      drawerOptions.add(new ListTile(
        leading: new Icon(Icons.layers),
        title: new Text(signout),
        onTap: () => showAppDialog(context),
      ));
    }
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.language),
      title: new Text(aboutUs),
      onTap: (){
        launchURL(goVidhnyanUrl);
        //sendSms();
      }
    ));
  return drawerOptions;
  }

  static const platform = const MethodChannel('sendSms');
  Future<Null> sendSms()async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+919960564245","msg":"Hello! I'm sent programatically."}); //Replace a 'X' with 10 digit phone number
      print(result);
      } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<Null> whatsApp()async {
    print("whatsApp");
    try {
      final String result = await platform.invokeMethod('whatsapp',<String,dynamic>{"phone":"+919960564245","msg":"Hello! I'm sent programatically."}); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

}
