import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';
import 'package:govidhyan_flutter/widgets/controller/loginController.dart';
import 'package:govidhyan_flutter/widgets/dialogs/exceptionDialog.dart';
import 'package:govidhyan_flutter/widgets/screens/homescreen.dart';
import 'package:govidhyan_flutter/exception/loginException.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return LoginWidget();
  }
}

class LoginWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}

class LoginState extends State<LoginWidget>{
  LoginController controller=LoginController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController userNameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool singup=false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return
       Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key:this._formKey,
        child: ListView(children: <Widget>[
        TextFormField(
          controller: userNameController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: mobileNumber
          ),
            validator: (value){
              return controller.validateUserId(value);
            }
        ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                labelText: password
            ),validator: (value){
              //have the string length between 6 to 12
              //for testing use 4 length
                return controller.validatePassword(value);
              }
          ),
          Container(
            width: screenSize.width,
            child: Column(
              children: <Widget>[RaisedButton(
                child: Text(
                  submit,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                  try{
                  Coordinator user=Coordinator(int.parse(userNameController.text),passwordController.text);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(processing),));
                  var response=await LoginController.sendLoginRequest(user);
                  if(response is Coordinator){
                    if(response.role.name==admin||response.role.name==coordinator) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context) {
                                HomeScreen screen = HomeScreen.co(
                                    response, true);
                                return screen;
                              }
                          )
                      );
                    }else{
                      throw LoginFailureException("No Valid Roles assigned to you.Please contact your Admin");
                    }
                  }
                } on LoginFailureException catch (e) {
                    showexceptionDialog(context,"Login Failure",e.message);
                    Scaffold.of(context).hideCurrentSnackBar();
                }on NetworkFailureException catch(e) {
                    showexceptionDialog(context,"Network Error",e.msg);
                    Scaffold.of(context).hideCurrentSnackBar();
                } catch(e){
                    showexceptionDialog(context,"Fatal Error","Please Try After some time");
                    Scaffold.of(context).hideCurrentSnackBar();
                  }
                  }
                },
                color: Colors.lightGreen,
              ),
              ],
            ),
            margin: EdgeInsets.only(top: 20.0),
          )
      ],),
      ),
       );
  }
}

