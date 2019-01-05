import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/screens/loginscreen.dart';
import 'package:govidhyan_flutter/widgets/screens/govidhyanapp.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/model/userinformation.dart';

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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int _currenStep = 0;
  var info=UserInformation();
  String dropDownValue;
  @override
  Widget build(BuildContext context) {

    return Form(
      child: Stepper(
            controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Row(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new RawMaterialButton(
                    onPressed: onStepCancel,
                    child: new Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.lightGreen,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  new RawMaterialButton(
                    onPressed: onStepContinue,
                    child: new Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.lightGreen,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ],
              );
            },
              steps: _getsignupSteps(),
              currentStep: this._currenStep,
              type: StepperType.horizontal,
              onStepContinue: (){
                setState(() {
                  if(this._currenStep<this._getsignupSteps().length-1){
                    this._currenStep=this._currenStep+1;
                  }else{
                      //signup activity is complete go to home screen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                      HomeScreen screen=HomeScreen();
                      screen.signedUp=true;
                      return screen;
                    }));
                  }
                });
              },
            onStepCancel: (){
                setState(() {
                  if(this._currenStep>0){
                    this._currenStep=this._currenStep-1;
                  }
                });
            },
            ),
    );
  }
  List<Step> _getsignupSteps(){
  List<Step> steps=[
    Step(
       title: Text(personal),
       content: Container(decoration: BoxDecoration(border: Border.all(width: 2.0,color: Colors.lightGreen)),
         child: Column(
         children: <Widget>[
           TextFormField(
             key: Key(name),
             decoration: InputDecoration(labelText: fullName),
           ),
           TextFormField(
             key: Key(mobileNumber),
             decoration: InputDecoration(labelText: mobileNumber),
           ),
           TextFormField(
             key: Key(address),
             decoration: InputDecoration(labelText: address),
           )
         ],
       )),
       isActive: _currenStep>=0,
    ),
    Step(
        title: Text(land),
        content: Container(decoration: BoxDecoration(border: Border.all(width: 2.0,color: Colors.lightGreen)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    Title(color: Colors.lightGreen, child: Text(land_size,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                    Divider(
                      height: 30,
                      color: Colors.lightGreen,
                    ),
                    TextFormField(
                      key: Key(land_size),
                      initialValue: init_0,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: land_size+' '+acres),
                    ),
                    TextFormField(
                      key: Key(jirayati_size),
                      keyboardType: TextInputType.number,
                      initialValue: init_0,
                      decoration: InputDecoration(labelText: jirayati),
                    ),
                    TextFormField(
                      key: Key(bagayati_size),
                      keyboardType: TextInputType.number,
                      initialValue: init_0,
                      decoration: InputDecoration(labelText: bagayati),
                    ),
                    Divider(
                      height: 30,
                      color: Colors.white,
                    ),
                    Title(color: Colors.lightGreen, child: Text(irr,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                    Divider(
                      height: 30,
                      color: Colors.lightGreen,
                    ),
                    Container(child:Row(
                        children:[
                          Expanded(child:Text(irr_type,style: TextStyle(fontWeight: FontWeight.bold),)),
                          FittedBox(child:DropdownButton<String>(
                            items: <String>[irr_type_well,irr_type_bore,irr_type_canal].map((f){
                              return new DropdownMenuItem<String>(child: Text(f));
                            }).toList()
                            ,onChanged: (_){},
                          ),
                          )])
                    ),
                    TextFormField(
                      key: Key(irr_land),
                      initialValue: init_0,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: irr_land_str),
                    ),
                    ],
                    ),
                  ),
        isActive: _currenStep>=1
    ),
    Step(
        title: Text(farm_asset),
        content: TextFormField(),
        isActive: _currenStep>=2
    )
  ];
  return steps;
  }
}
