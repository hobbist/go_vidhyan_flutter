import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';

class FarmerRegistrationScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FarmerRegistrationState();
  }
}

class FarmerRegistrationState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ListView(children:[
      Container(
        padding: EdgeInsets.all(20.0),
        child:Form(
        key: _formKey,
        child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(decoration:
                            InputDecoration(border:
                                          OutlineInputBorder(),hintText: farmer_name,hintStyle: TextStyle(color: Colors.lightGreen)),
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if(value.length>50 || value.length<5){
                              return farmer_name_validation;
                            }
                          }),
            TextFormField(decoration:
                            InputDecoration(border:
                                            OutlineInputBorder(),hintText: mobileNumber,hintStyle: TextStyle(color: Colors.lightGreen)),
                          keyboardType: TextInputType.number,
                          validator: (value){
                            if(value.length>12 || value.length<10){
                              return mobile_number_validation;
                            }
                          }),
            Padding(padding: EdgeInsets.all(10.0),
                    child:RaisedButton(
                                      color: Colors.lightGreen,
                                      onPressed: (){
                                        if(_formKey.currentState.validate()){
                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(processing),));
                                        }

                                      },
                                      child: Text(submit,style: TextStyle(color: Colors.white),),
            ) ,),
            ],
        ),
      ),
    ))]);
  }
}