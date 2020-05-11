import 'dart:async';
import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/model/drawerItem.dart';
import 'package:govidhyan_flutter/widgets/dao/appDatabase.dart';
import 'package:govidhyan_flutter/widgets/screens/farmerRegistration.dart';
import 'package:govidhyan_flutter/widgets/screens/loginscreen.dart';
import 'package:govidhyan_flutter/widgets/screens/mapCoordinatorCity.dart';
import 'package:govidhyan_flutter/widgets/screens/pendingUserList.dart';
import 'package:govidhyan_flutter/widgets/screens/signupscreen.dart';
import 'package:govidhyan_flutter/widgets/screens/stages.dart';
import 'package:govidhyan_flutter/model/action.dart';
import 'package:govidhyan_flutter/widgets/screens/whatsNewScreen.dart';
import 'package:sqflite/sqflite.dart';

class DrawerHandler{
  final _drawerItems = [new DrawerItem(login, Icons.alternate_email,LoginScreen()),new DrawerItem(signup, Icons.accessibility,SignupScreen())];
  //TODO - add farmer stages page in list when implemented
  //new DrawerItem(check_farmer_stages, Icons.assessment,StagesScreen())
  final _homeDrawerItems = [new DrawerItem(check_pending_registrations, Icons.person_add,PendingUserListScreen()),new DrawerItem(add_farmer_contact, Icons.account_box,FarmerRegistrationScreen()),new DrawerItem.empty(contact_Admin, Icons.perm_phone_msg),new DrawerItem(whatsNew,Icons.flare,WhatsNewScreen())];
  final _adminDrawer= [new DrawerItem(check_pending_registrations, Icons.person_add,PendingUserListScreen()),new DrawerItem(add_farmer_contact, Icons.account_box,FarmerRegistrationScreen()),new DrawerItem(change_coordinator_cities, Icons.assessment,MapCoordinatorCityScreen()),new DrawerItem(whatsNew,Icons.flare,WhatsNewScreen())];
  Future<List<DrawerItem>> getDrawerItemsForUser (Coordinator coordinator) async{
    var drawer=_drawerItems;
    //TODO - call http service to get drawer items based on user role
    Future future=Future.delayed(const Duration(seconds: 3),()=>drawer);
    if(coordinator!=null){
      drawer=_homeDrawerItems;
      if(coordinator.role.name=="admin"){
        drawer=_adminDrawer;
      }
      future=Future.delayed(const Duration(seconds: 3),()=>drawer);
    }
    return await future;
  }
}