import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var array=['Well','Boring','Canel','Dam'];
    String selectedWaterArrangement=array[0];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: this._formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: fullName),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: address),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: mobileNumber),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Jirayati'),
                  initialValue: '0',
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '0',
                  decoration: InputDecoration(labelText: 'Bagayati'),
                ),
                DropdownButton<String>(
                  value: selectedWaterArrangement,
                  items: array.map((String f) {
                    return DropdownMenuItem<String>(
                      value: f,
                      child: Text(f),
                    );
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      selectedWaterArrangement=value;
                    });
                  },
                )
              ],
            ),
          )),
    );
  }
}
