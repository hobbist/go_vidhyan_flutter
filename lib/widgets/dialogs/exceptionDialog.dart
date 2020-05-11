import 'package:flutter/material.dart';

showexceptionDialog(BuildContext context, String title,String message){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(title: Text(title),
                         content: Text(message),
      );
      },
  );
}