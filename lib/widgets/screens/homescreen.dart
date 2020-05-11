import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/components/drawer.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/utils/functions.dart';
import 'package:govidhyan_flutter/model/drawerItem.dart';
import 'package:govidhyan_flutter/widgets/controller/homeScreenController.dart';
import 'package:govidhyan_flutter/widgets/controller/userDataController.dart';
import 'package:govidhyan_flutter/widgets/screens/signoutDialog.dart';

class HomeScreen extends StatefulWidget{
  Coordinator _coordinator;
  bool _singedUp=false;
  String _snackBarMessage=null;
  HomeScreen._internal();

  static final HomeScreen _home=HomeScreen._internal();
  static final DrawerHandler handler=DrawerHandler();
  var drawer=null;
  factory HomeScreen(){
    return _home;
  }

  factory HomeScreen.co(Coordinator coordinator,bool signedUp){
    _home._singedUp=signedUp;
    _home._coordinator=coordinator;
    UserData.user=coordinator;
    return _home;
  }

  void set signedUp(bool up){
    this._singedUp=up;
  }

  bool get signedUp{
    return this._singedUp;
  }

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState(this.signedUp);
  }

  Coordinator get coordinator => _coordinator;

  set coordinator(Coordinator value) {
    UserData.user=value;
    _coordinator = value;
  }

  bool get singedUp => _singedUp;

  set singedUp(bool value) {
    _singedUp = value;
  }

  Future<List<DrawerItem>> getHomedrawer(){
    //TODO - include Role based logic
    drawer=handler.getDrawerItemsForUser(this.coordinator);
    return drawer;
  }

  String get snackBarMessage => _snackBarMessage;

  set snackBarMessage(String value) {
    _snackBarMessage = value;
  }
}

class HomeScreenState extends State<HomeScreen>{
  bool _signedUp=false;
  HomeScreenState(this._signedUp);
  DrawerItem _selectedDrawerIndex;

  @override
  void initState() {
    //coordinator=HomeScreenController.getCoordinatorFromLocalDB();
  }

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
    return FutureBuilder<List<DrawerItem>>(
        future: HomeScreen().getHomedrawer(),
        builder: (BuildContext context, AsyncSnapshot<List<DrawerItem>> snapshot) {
          if(snapshot.hasError){
            //TODO- widget showing error
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: Center(child: Text("App Error happened.Please Contact Admin."),),
            );
          }else{
            if(snapshot.hasData){
              return Scaffold(
                appBar: AppBar(title: Text(title)),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: buildDrawerOptions(
                        snapshot.data),
                  ),
                ),
                body: _getDrawerItemWidget(context, _selectedDrawerIndex),
              );
            }else{
              return new Scaffold(
                body:  Center(child: CircularProgressIndicator(),),
              );
            }
          }
        }
    );
  }
  List<Widget> buildDrawerOptions(List<DrawerItem> drawer){
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
    if(_selectedDrawerIndex==null){
    _selectedDrawerIndex=drawer[0];
    }
    return drawerOptions;
  }
}