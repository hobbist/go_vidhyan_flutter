import 'package:flutter/material.dart';
class DrawerItem {
  String title;
  IconData icon;
  Widget page;
  bool dialog=false;
  DrawerItem(this.title, this.icon,this.page);
  DrawerItem.empty(this.title, this.icon);
  DrawerItem.dialog(this.title, this.icon,this.dialog);

  @override
  String toString() {
    return 'DrawerItem{title: $title, icon: $icon, page: $page, dialog: $dialog}';
  }

}
