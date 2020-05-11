import 'package:flutter/material.dart';

showSnackBar(BuildContext context,message){
  if(message!=null&&message!="") {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
        ));
  }
}