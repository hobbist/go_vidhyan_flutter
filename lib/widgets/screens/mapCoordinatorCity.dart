import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/controller/mapCoordinatorCityContoller.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/widgets/dialogs/exceptionDialog.dart';

class MapCoordinatorCityScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapCoordinatorCityState();
  }

}
class MapCoordinatorCityState extends State<MapCoordinatorCityScreen>{
  final MapCoordinatorToCityController controller =MapCoordinatorToCityController();
//for multiselect cities
//https://medium.com/@sarbagyastha/flutter-package-flutter-tagging-multi-select-4457bcb396b4
//https://github.com/sarbagyastha/flutter_tagging/tree/master/example
// TODO: Handle Error for fetching cities or coordinator details also for sending information back to server.
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    String dropDownValue;
    Coordinator coordinatorSelected;
    List<Coordinator> coordinators=List<Coordinator>();
    String text = "City1";
    dynamic cities;
    var citiVals=List<String>();
  String errorText="";
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(20.0),child:SingleChildScrollView(
        child: Column(
          children: <Widget>[DropdownButtonFormField<Coordinator>(
              hint: Text("Select CoorDinator")
              ,value:coordinatorSelected,
              items: coordinators.map((Coordinator str){return DropdownMenuItem<Coordinator>(value:str,child: Text(str.name));}).toList()
              ,onChanged: (value){
            setState(() {
              coordinatorSelected=value;
            });
          }),
      Padding(
          padding: const EdgeInsets.only(top: 25.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterTagging(
                textFieldDecoration: InputDecoration(
                 border: OutlineInputBorder(),
                 hintText: "Cities",
                 labelText: "Enter Cities"),
                //addButtonWidget: _buildAddButton(),
                chipsColor: Colors.lightGreen,
                chipsFontColor: Colors.white,
                deleteIcon: Icon(Icons.cancel,color: Colors.white),
                chipsPadding: EdgeInsets.all(2.0),
                chipsFontSize: 14.0,
                chipsSpacing: 5.0,
                chipsFontFamily: 'helvetica_neue_light',
                suggestionsCallback: (pattern) async {
                  return await controller.fetchCitiesFromQuery(pattern,citiVals);
                },
                onChanged: (result) {
                  setState(() {
                    text = result.toString();
                    cities=result;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          Center(
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
          ),
            Center(child:RaisedButton(
                child: Text(
                  submit,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed:() async{
                    try{
                    if(cities==null) {
                      errorText = "No Cities Selected";
                    }
                    if(coordinatorSelected==null){
                      errorText="Please select coordinator";
                    }
                    //Call Api with coordinator name and cities
                    //handle errors
                   await controller.mapCoordinatorToCities(coordinatorSelected, cities);
                    showexceptionDialog(context, 'Success','Coordinator Successfully Assigned with cities');
                    setState(() {
                      cities=null;
                      text=null;
                      errorText='';
                    });

                  }  on NetworkFailureException catch(e){
                      showexceptionDialog(context,"Citi Coordinator Mapping",e.msg);
                  }
                } ,
                color: Colors.lightGreen))
        ],
        ),
      ));
  }
  @override
  void initState() {
    super.initState();
    try {
      fetchcities();
      fetchCoordinators();
    }on NetworkFailureException catch(e){
      showexceptionDialog(context, 'Failure', "Fail To load coordinator/city data");
    }
  }
  fetchcities() async{
    try {
      var citi = await controller.fetchCities();
      setState(() {
        citiVals = citi;
      });
    }on Exception{
      showexceptionDialog(context, "Cities","Network Error happened fetching data");
    }
  }

  void fetchCoordinators() async{
    try {
    var coo=await controller.fetchCoordinators();
    setState(() {
      coordinators=coo;
    });
    }on Exception{
      showexceptionDialog(context, "Coordinators","Network Error happened fetching data");
    }
  }
}