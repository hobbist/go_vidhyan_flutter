import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/model/userinformation.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';
import 'package:govidhyan_flutter/widgets/controller/registrationController.dart';
import 'package:govidhyan_flutter/exception/requestRegistrationException.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/widgets/dialogs/exceptionDialog.dart';

class FarmerRegistrationScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FarmerRegistrationState();
  }
}

class FarmerRegistrationState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  static final RegistrationController controller=RegistrationController();
  TextEditingController nameController=TextEditingController();
  TextEditingController numberController=TextEditingController();
  String dropDownValue=null;
  var cities=List<String>();
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
            TextFormField(controller: nameController,decoration:
                            InputDecoration(border:
                                          UnderlineInputBorder(),labelText: farmer_name,labelStyle: TextStyle(color: Colors.lightGreen)),
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if(value.length>50 || value.length<5){
                              return farmer_name_validation;
                            }
                          }),
            TextFormField(controller: numberController,decoration:
                            InputDecoration(border:
                                          UnderlineInputBorder(),labelText: mobileNumber,labelStyle: TextStyle(color: Colors.lightGreen)),
                          keyboardType: TextInputType.number,
                          validator: (value){
                            if(value.length>12 || value.length<10){
                              return mobile_number_validation;
                            }
                          }),
                DropdownButtonFormField<String>(
                validator: (value){
                if(value==null){
                return "Please select a city";
                }
                },
               hint: Text("Select City")
               ,value:dropDownValue,
               items: cities.map((String str){return DropdownMenuItem<String>(value: str,child: Text(str));}).toList()
              ,onChanged: (value){
                 print(value);
                 setState(() {
                   dropDownValue=value;
                 });}),
            Padding(padding: EdgeInsets.all(10.0),
                    child:RaisedButton(
                                      color: Colors.lightGreen,
                                      onPressed: () async{
                                        try {
                                          if (_formKey.currentState
                                              .validate()) {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(processing),));
                                            await controller.sendRegistration(FarmerInformation.withCity(nameController.text,int.parse(numberController.text),dropDownValue));
                                            showexceptionDialog(context, title, 'Successfully sent link to ${nameController.text}');
                                            Scaffold.of(context).hideCurrentSnackBar();
                                            setState(() {
                                              nameController.text='';
                                              numberController.text='';
                                            });
                                          }
                                        }on RequestRegistrationException catch(e){
                                          Scaffold.of(context).hideCurrentSnackBar();
                                          showexceptionDialog(context, title, e.msg);

                                        }on NetworkFailureException catch(e){
                                          showexceptionDialog(context, title, e.msg);
                                          Scaffold.of(context).hideCurrentSnackBar();
                                        }
                                      },
                                      child: Text(submit,style: TextStyle(color: Colors.white),),
            ) ,),
            ],
        ),
      ),
    ))]);
  }

  @override
  void initState() {
    super.initState();
      fetchcities();

  }
  fetchcities() async{
    try {
      var citi = await controller.fetchCities();
      setState(() {
        cities=citi;
      });
    }on NetworkFailureException catch(e){
      showexceptionDialog(context, "Cities", "Failed to load cities");
    }
  }
}