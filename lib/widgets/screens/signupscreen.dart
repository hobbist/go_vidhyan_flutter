import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/model/userinformation.dart';
class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<SignupScreen> with TickerProviderStateMixin<SignupScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int _currenStep = 0;
  var info=UserInformation();
  String dropDownValue;
  @override
  Widget build(BuildContext context) {

    return Form(
      child:Scaffold(
            appBar: AppBar(
            title: Text('Signup'),
          ),
          body: Stepper(
              steps: _getsignupSteps(),
              currentStep: this._currenStep,
              type: StepperType.horizontal,
              onStepContinue: (){
                setState(() {
                  if(this._currenStep<this._getsignupSteps().length-1){
                    this._currenStep=this._currenStep+1;
                  }else{
                    //TODO -- logic to complete all steps
                    print('Completed');
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
        ),
    );
  }
  List<Step> _getsignupSteps(){
  List<Step> steps=[
    Step(
       title: Text('personal'),
       content: Container(
         child: Column(
         children: <Widget>[
           TextFormField(
             key: Key('Name'),
             decoration: InputDecoration(labelText: 'Full Name e.g Narayan Jatkar'),
           ),
           TextFormField(
             key: Key('mobile_number'),
             decoration: InputDecoration(labelText: 'Mobile Number'),
           ),
           TextFormField(
             key: Key('address'),
             decoration: InputDecoration(labelText: 'Address'),
           )
         ],
       )),
       isActive: _currenStep>=0,
    ),
    Step(
        title: Text('Land'),
        content: Container(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    Title(color: Colors.lightGreen, child: Text('Land Size',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                    Divider(
                      height: 30,
                      color: Colors.lightGreen,
                    ),
                    TextFormField(
                      key: Key('land_size'),
                      initialValue: '0',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Land Size in Acre'),
                    ),
                    TextFormField(
                      key: Key('jirayati_size'),
                      keyboardType: TextInputType.number,
                      initialValue: '0',
                      decoration: InputDecoration(labelText: 'Size of Jirayati land'),
                    ),
                    TextFormField(
                      key: Key('bagayati_size'),
                      keyboardType: TextInputType.number,
                      initialValue: '0',
                      decoration: InputDecoration(labelText: 'Size of Bagayati land'),
                    ),
                    Divider(
                      height: 30,
                      color: Colors.white,
                    ),
                    Title(color: Colors.lightGreen, child: Text('Irrigation',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                    Divider(
                      height: 30,
                      color: Colors.lightGreen,
                    ),
                    Container(child:Row(
                        children:[
                          Expanded(child:Text('Irrigation Type',style: TextStyle(fontWeight: FontWeight.bold),)),
                          FittedBox(child:DropdownButton<String>(
                            items: <String>['Well','Boring','Canal'].map((f){
                              return new DropdownMenuItem<String>(child: Text(f));
                            }).toList()
                            ,onChanged: (_){},
                          ),
                          )])
                    ),
                    TextFormField(
                      key: Key('irrigated_land'),
                      initialValue: '0',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Land under irrigation'),
                    ),
                    ],
                    ),
                  ),
        isActive: _currenStep>=1
    ),
    Step(
        title: Text('Farming assets'),
        content: TextFormField(),
        isActive: _currenStep>=2
    )
  ];
  return steps;
  }
}
