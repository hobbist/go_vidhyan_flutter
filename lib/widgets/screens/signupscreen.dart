import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/model/city.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';
import 'package:govidhyan_flutter/widgets/controller/signupController.dart';
import 'package:govidhyan_flutter/widgets/dialogs/exceptionDialog.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/exception/signupException.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/widgets/screens/homescreen.dart';
import 'package:govidhyan_flutter/exception/citiNotFetchedException.dart';


class SignupScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SignupWidget();
  }
}
class SignupWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<SignupWidget> with TickerProviderStateMixin<SignupWidget> {
  final SignupController controller =SignupController();
  final TextEditingController nameController=TextEditingController();
  final TextEditingController mobNumController=TextEditingController();
  final TextEditingController addrController=TextEditingController();
  final TextEditingController passController=TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String dropDownValue;
  var cities=List<String>();
  @override
  Widget build(BuildContext context) {

    return  ListView(children:[
      Container(
          padding: EdgeInsets.all(20.0),
          child:Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(controller: mobNumController,decoration:
                  InputDecoration(border:
                  UnderlineInputBorder(),labelText: mobileNumber,labelStyle: TextStyle(color: Colors.lightGreen)),
                      keyboardType: TextInputType.number,
                      validator: (value){
                        return controller.validateMobileNumber(value);
                      }),
                  TextFormField(controller: nameController,decoration:
                  InputDecoration(border:
                  UnderlineInputBorder(),labelText: fullName,labelStyle: TextStyle(color: Colors.lightGreen)),
                      keyboardType: TextInputType.text,
                      validator: (value){
                        return controller.validateFarmerName(value);
                      }),
                  //Text("City"),
                    DropdownButtonFormField<String>(
                        validator: (value){
                      if(value==null){
                        return "Please select a city";
                      }
                    },hint: Text("Select City"),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                      )
                      ,value:dropDownValue,
                      items: cities.map((String str){return DropdownMenuItem<String>(value: str,child: Text(str));}).toList()
                      ,onChanged:(value){setState(() {
                       dropDownValue=value;
                  });}),
                  TextFormField(controller: addrController,decoration:InputDecoration(labelText: address),maxLines: null,keyboardType: TextInputType.multiline,validator: (value){return controller.validateAddress(value);}),
                  TextFormField(controller: passController,decoration:InputDecoration(labelText: password,),maxLines: null, obscureText: true,validator: (value){return controller.validatePassword(value);},),
                  Padding(padding: EdgeInsets.all(10.0),
                    child:RaisedButton(
                      color: Colors.lightGreen,
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(processing),));
                          //Send Registrationrequest of coordinator
                          //prepare coordinator object
                          try {
                            Coordinator c=Coordinator(int.parse(mobNumController.text),passController.text);
                            c.name=nameController.text;
                            c.address=addrController.text;
                            List<City> cities=new List();
                            City selectedCity=new City();
                            selectedCity.name=dropDownValue;
                            cities.add(selectedCity);
                            c.cities=cities;
                            var r=await controller.senRegistrationRequest(c);
                            if(r is Coordinator){
                              if(r.status!=null&&r.status=="pending_approval"){
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          HomeScreen screen = HomeScreen.co(null, false);
                                          screen.snackBarMessage="Signup Request completed.Please Login Again";
                                          return screen;
                                        }
                                    )
                                );
                              }
                            }
                          }on SignupException catch (e){
                            showexceptionDialog(context,"Signup Failure",e.msg);
                          }on CitiNotFetchedException catch (e) {
                            showexceptionDialog(context, "Mandatory Information", e.message);
                          }on NetworkFailureException catch(e){
                            showexceptionDialog(context,"Fatal Error",e.msg);
                          }on Exception{
                            showexceptionDialog(context, "Fatal Error","Unable to complete signup process");
                          }
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
    var citi= await controller.fetchCities();
    setState(() {
      cities=citi;
    });
  }
}
