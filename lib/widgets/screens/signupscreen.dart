import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<SignupScreen> with TickerProviderStateMixin<SignupScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int _tabIndex = 0;
    var tab=TabController(
      length: 3,
      vsync: this,
      initialIndex: 0
    );
    void _handleTabSelection(){
      setState(() {
        tab.index = _tabIndex;
      });
    }
    tab.addListener(_handleTabSelection);
    return Form(
      child: DefaultTabController(length: 3,initialIndex: 0, child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
                  GestureDetector(child:Text('Personal Info'),onTap: ()=>_tabIndex=0,),
                  GestureDetector(child:Text('Land'),onTap: ()=>_tabIndex=0),
                  GestureDetector(child:Text('Family'),onTap: ()=>_tabIndex=0)],
                  controller: tab,
          ),
          title: Text('Signup'),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(),children: [
          TextFormField(keyboardType: TextInputType.number,decoration: InputDecoration(labelText: 'Mobile Number'),),
          TextFormField(keyboardType: TextInputType.number,decoration: InputDecoration(labelText: 'Land Size'),),
          TextFormField(keyboardType: TextInputType.number,decoration: InputDecoration(labelText: 'Family Members'),)
        ]),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.lightGreen,onPressed: null,tooltip: 'next',child: Icon(Icons.arrow_right),),
      )),
    );
  }
}
