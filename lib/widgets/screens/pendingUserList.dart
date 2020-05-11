import 'package:flutter/material.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/model/userinformation.dart';
import 'package:govidhyan_flutter/widgets/components/snackbar.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/controller/pendingUserListController.dart';
import 'package:govidhyan_flutter/widgets/controller/userDataController.dart';
import 'package:govidhyan_flutter/widgets/dialogs/exceptionDialog.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/exception/pendingListException.dart';

//TODO - catch exceptions on screen
class PendingUserListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PendingUserListState();
  }
}

class PendingUserListState extends State<PendingUserListScreen> {
  GlobalKey<RefreshIndicatorState> _farmerRefreshIndicatorKey= new GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> _farmerPendingRefreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> _coordinatorRefreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var farmerlist=<FarmerInformation>[];
  var farmerPendinglist=<FarmerInformation>[];
  var coordinatorlist=<Coordinator>[];
  var pendingFarmerCity=null;
  var adminPendingListForCity=<FarmerInformation>[];
  var pendingFarmerRegistrationCity=null;
  var adminPendingRegistrationListForCity=<FarmerInformation>[];
  var _state=0;
  var cities=List<String>();
  @override
  Widget build(BuildContext context) {

    try {
      if (UserData.user?.role?.name == "admin") {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
              bottomNavigationBar: Container(child:TabBar(tabs: [
                Tab(child: Text(
                    "Approvals ${farmerlist?.length >= 0 ? "(${farmerlist
                        .length})" : ""}"),),
                Tab(child: Text(
                    "Registrations ${farmerPendinglist?.length >= 0 ? "(${farmerPendinglist
                        .length})" : ""}"),),
                Tab(child: Text("Coordinators ${coordinatorlist?.length >= 0
                    ? "(${coordinatorlist?.length})"
                    : ""}"),)
              ])),
            body: TabBarView(
              children: generateRefreshList(UserData.user),
            ),
          ),
        );
      } else if (UserData.user?.role?.name == "coordinator") {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomNavigationBar: Container(
              child:TabBar(tabs: [
              Tab(child: Text(
                  "Approvals ${farmerlist?.length >= 0 ? "(${farmerlist
                      .length})" : ""}"),),
              Tab(child: Text(
                  "Registrations ${farmerPendinglist?.length >= 0 ? "(${farmerPendinglist
                      .length})" : ""}"),)
              ])
            ),
            body: TabBarView(
              children: generateRefreshList(UserData.user),
            ),
          ),
        );
      } else {
        return Center(child:Text("Fatal Error while retriving your privileges"));
      }
    } on NetworkFailureException catch(e){
      showexceptionDialog(context,"Exception completing request",e.msg);
      //show dialog for error
    } on Exception{
      showexceptionDialog(context,"Fatal Error","Unexpected error happened.Please contact Admin");
    }
  }

  List<Widget> generateRefreshList(Coordinator userObj){
    List<Widget> widgets=[getPendingFarmerViewByRole(userObj),getPendingFarmerRegistrationViewByRole(userObj)];
    if(userObj.role.name=="admin"){
      widgets.add(
          RefreshIndicator(
            key: _coordinatorRefreshIndicatorKey,
            onRefresh:()=> _refreshCoordinatorList("coordinator",UserData.user.tokenNum),
            child: Container(
                child: ListView.builder(
                    padding: EdgeInsets.all(20.0),
                    itemCount: coordinatorlist.length,
                    itemBuilder: (BuildContext context, int count) {
                      return Card(
                          elevation: 3.0,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Image(image: AssetImage(imageLogoPath),),
                            ListTile(contentPadding: EdgeInsets.all(1.0),
                            title:Center(child:Text("${coordinatorlist[count].name}")),
                            onTap: (){
                              //detail view
                              print('coordinator ${coordinatorlist[count]} is clicked');
                            },
                            subtitle:Center(child:Text("${coordinatorlist[count].mobNumber}" )),
                          ),
                          ButtonTheme.bar(
                            child: ButtonBar(mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              RaisedButton(onPressed: () async {
                                try {
                                  coordinatorlist = await
                                      PendingUserListController.actOnUser(
                                          count, coordinatorlist,
                                          "Approve_Coordinator");
                                  showexceptionDialog(context, title,"Successfully Approved");
                                }on PendingListException catch(e){
                                  if(e.code!=null&& (e.code=="COORDINATOR_ALREADY_APPROVED")){
                                    //remove from DB
                                    coordinatorlist.removeAt(count);
                                  }
                                  showexceptionDialog(context, title, e.msg);
                                } on NetworkFailureException catch(e){
                                  showexceptionDialog(context, title, e.msg);
                                }
                                setState(() {
                                });},child: Icon(Icons.check,color: Colors.white,),color: Colors.lightGreen),
                              RaisedButton(onPressed: () async {
                                try {
                                coordinatorlist=await PendingUserListController.actOnUser(count, coordinatorlist,"Reject_Coordinator");
                                showexceptionDialog(context, title,"Successfully Rejected");
                                }on PendingListException catch(e){
                                  if(e.code!=null&& ( e.code=="COORDINATOR_ALREADY_REJECTED")){
                                    //remove from DB
                                    coordinatorlist.removeAt(count);
                                  }
                                  showexceptionDialog(context, title, e.msg);
                                }on NetworkFailureException catch(e){
                                  showexceptionDialog(context, title, e.msg);
                                }
                                setState(()  {
                              });},child: Icon(Icons.clear,color: Colors.white),color: Colors.red,)
                              ],
                            ),
                          )
                          ],)
                      );
                    })
            ),
          )
      );
    }
    return widgets;
  }

  Widget getPendingFarmerViewByRole(Coordinator userObj){
    switch (userObj.role.name){
      case "coordinator":{
        return RefreshIndicator(key: _farmerRefreshIndicatorKey,
          onRefresh:()=> _refreshCoordinatorFarmer(userObj.tokenNum),
          child: Container(
              child: ListView.builder(
                  padding: EdgeInsets.all(20.0),
                  itemCount: farmerlist.length,
                  itemBuilder: (BuildContext context, int count) {
                    return Card(
                      //TODO -- popup to confirm approval or denial
                      //TODO -- remove from list only when we get response as approved or reject from server
                        elevation: 3.0,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage(imageLogoPath),),
                            ListTile(contentPadding: EdgeInsets.all(1.0),
                              title:Center(child:Text("${farmerlist[count].name}")),
                              onTap: (){
                                print('farmer ${farmerlist[count]} is clicked');
                              },
                              subtitle:Center(child:Text("${farmerlist[count].mobNumber}   ${farmerlist[count].city}" )),
                            ),
                            ButtonTheme.bar(
                              child: ButtonBar(mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RaisedButton(onPressed: () async{
                                    try {
                                      farmerlist = await
                                          PendingUserListController.actOnUser(
                                              count, farmerlist,
                                              "Approve_Farmer");
                                      showexceptionDialog(context, title,"Successfully Approved");
                                    }on PendingListException catch(e){
                                      if(e.code!=null&& (e.code=="FARMER_ALREADY_APPROVED")){
                                        //remove from DB
                                        farmerlist.removeAt(count);
                                      }
                                      showexceptionDialog(context, title, e.msg);
                                    }on NetworkFailureException catch(e){
                                      showexceptionDialog(context, title, e.msg);
                                    }
                                    setState(()  {
                                  });},child: Icon(Icons.check,color: Colors.white,),color: Colors.lightGreen),
                                  RaisedButton(onPressed: () async {
                                    try {
                                      farmerlist = await
                                          PendingUserListController.actOnUser(
                                              count, farmerlist,
                                              "Reject_Farmer");
                                      showexceptionDialog(context, title,"Successfully Rejected");
                                     }on PendingListException catch(e){
                                      if(e.code!=null&& (e.code=="FARMER_ALREADY_REJECTED")){
                                        //remove from DB
                                        farmerlist.removeAt(count);
                                      }
                                          showexceptionDialog(context, title, e.msg);
                                      }on NetworkFailureException catch(e){
                                      showexceptionDialog(context, title, e.msg);
                                    }
                                    setState(() {
                                  });},child: Icon(Icons.clear,color: Colors.white),color: Colors.red,)
                                ],
                              ),
                            )
                          ],)
                    );
                  })
          ),
        );
      }
      break;
      case "admin": {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
                DropdownButton<String>(
                hint: Text("Select City")
                ,value:pendingFarmerCity,
                items: cities.map((String str){return DropdownMenuItem<String>(value: str,child: Text(str));}).toList()
                ,onChanged: (value){
                setState(() {
                  pendingFarmerCity=value;
                });
        }),
        RaisedButton(color: Colors.lightGreen,child:setUpButtonChild(),onPressed: () async{
          try{
          animateButton(true);
          var list=await PendingUserListController.sendPendingApprovalFarmerListForAdmin(pendingFarmerCity);
          if(list==null||list.length==0){
            showSnackBar(context,"No Records Found");
          }
          setState(() {
            //check if city value is empty.
            //add check if failed to get list
              animateButton(false);
              farmerlist=list;
          });}on NetworkFailureException catch(e){
            //show dialog for network failure
            showexceptionDialog(context, title, e.msg);
            animateButton(false);
          }
        },)
        ],),
          Expanded(child:Container(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(20.0),
                itemCount: farmerlist.length,
                itemBuilder: (BuildContext context, int count) {
              return Card(
                //TODO -- popup to confirm approval or denial
                //TODO -- remove from list only when we get response as approved or reject from server
                  elevation: 3.0,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage(imageLogoPath),),
                      ListTile(contentPadding: EdgeInsets.all(1.0),
                        title:Center(child:Text("${farmerlist[count].name}")),
                        onTap: (){
                          print('farmer ${farmerlist[count]} is clicked');
                        },
                        subtitle:Center(child:Text("${farmerlist[count].mobNumber}   ${farmerlist[count].city}" )),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RaisedButton(onPressed: () async {
                              try {
                                farmerlist = await
                                PendingUserListController.actOnUser(
                                    count, farmerlist, "Approve_Famrer");
                                showexceptionDialog(context, title,"Successfully Approved");
                              }on PendingListException catch(e){
                                if(e.code!=null&& (e.code=="FARMER_ALREADY_APPROVED")){
                                  //remove from DB
                                  farmerlist.removeAt(count);
                                }
                                showexceptionDialog(context, title, e.msg);
                              }on NetworkFailureException catch(e){
                                showexceptionDialog(context, title, e.msg);
                              }
                              setState((){
                            });},child: Icon(Icons.check,color: Colors.white,),color: Colors.lightGreen),
                            RaisedButton(onPressed: () async {
                              try {
                                farmerlist = await
                                    PendingUserListController.actOnUser(
                                        count, farmerlist, "Reject_Farmer");
                                showexceptionDialog(context, title,"Successfully Rejected");
                              } on PendingListException catch(e){
                                if(e.code!=null&& (e.code=="FARMER_ALREADY_REJECTED")){
                                  //remove from DB
                                  farmerlist.removeAt(count);
                                }
                                  showexceptionDialog(context, title, e.msg);
                              }on NetworkFailureException catch(e){
                                showexceptionDialog(context, title, e.msg);
                              }
                              setState(() {
                            });},child: Icon(Icons.clear,color: Colors.white),color: Colors.red,)
                          ],
                        ),
                      )
                    ],)
                  );
            }))
        )
        ]);
      }
      break;
    }
  }

  Widget getPendingFarmerRegistrationViewByRole(Coordinator userObj){
    switch (userObj.role.name){
      case "coordinator":{
        return RefreshIndicator(key: _farmerPendingRefreshIndicatorKey,
          onRefresh:()=> _refreshCoordinatorFarmerPendingRegistration(userObj.tokenNum),
          child: Container(
              child: ListView.builder(
                  padding: EdgeInsets.all(20.0),
                  itemCount: farmerPendinglist.length,
                  itemBuilder: (BuildContext context, int count) {
                    return Card(
                      //TODO -- popup to confirm approval or denial
                      //TODO -- remove from list only when we get response as approved or reject from server
                        elevation: 3.0,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage(imageLogoPath),),
                            ListTile(contentPadding: EdgeInsets.all(1.0),
                              title:Center(child:Text("${farmerPendinglist[count].name}")),
                              onTap: (){
                                print('farmer ${farmerPendinglist[count]} is clicked');
                              },
                              subtitle:Center(child:Text("${farmerPendinglist[count].mobNumber}   ${farmerPendinglist[count].city}" )),
                            ),
                          ],)
                    );
                  })
          ),
        );
      }
      break;
      case "admin": {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[DropdownButton<String>(
                  hint: Text("Select City")
                  ,value:pendingFarmerRegistrationCity,
                  items: cities.map((String str){return DropdownMenuItem<String>(value: str,child: Text(str));}).toList()
                  ,onChanged: (value){
                setState(() {
                  pendingFarmerRegistrationCity=value;
                });
              }),
              RaisedButton(color: Colors.lightGreen,child:setUpButtonChild(),onPressed: () async{
                try{
                  animateButton(true);
                  var list=await PendingUserListController.sendPendingRegistrationFarmerListForAdmin(pendingFarmerRegistrationCity);
                  if(list==null||list.length==0){
                    showSnackBar(context,"No Records Found");
                  }
                  setState(() {
                    //check if city value is empty.
                    //add check if failed to get list
                    animateButton(false);
                    farmerPendinglist=list;
                  });}on NetworkFailureException catch(e){
                  //show dialog for network failure
                  showexceptionDialog(context, title, e.msg);
                  animateButton(false);
                }
              },)
              ],),
              Expanded(child:Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(20.0),
                      itemCount: farmerPendinglist.length,
                      itemBuilder: (BuildContext context, int count) {
                        return Card(
                          //TODO -- popup to confirm approval or denial
                          //TODO -- remove from list only when we get response as approved or reject from server
                            elevation: 3.0,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(image: AssetImage(imageLogoPath),),
                                ListTile(contentPadding: EdgeInsets.all(1.0),
                                  title:Center(child:Text("${farmerPendinglist[count].name}")),
                                  onTap: (){
                                    print('farmer ${farmerPendinglist[count]} is clicked');
                                  },
                                  subtitle:Center(child:Text("${farmerPendinglist[count].mobNumber}   ${farmerPendinglist[count].city}" )),
                                ),
                              ],)
                        );
                      }))
              )
            ]);
      }
      break;
    }
  }



  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Submit",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void animateButton(bool t) {
    setState(() {
      _state = t?1:0;
    });
  }

  Future<Null> _refreshCoordinatorList(String listName,String userId) async {
    print('printing coordinator list');
    try {
      var list = await PendingUserListController.sendPendingApprovalCoordinatorListForAdmin();
      print("in screen"+ list.toString());
      setState(() {
        coordinatorlist = list!=null?list:[];
      }
      );
    }catch(e){

    }
    return null;
  }

  Future<Null> _refreshCoordinatorFarmer(String tokenNum) async {
    var list=await PendingUserListController.sendPendingApprovalFarmerListForCoordinator(tokenNum);
    setState(() {
      farmerlist=list!=null?list:[];
    }
    );
    return null;
  }

  Future<Null> _refreshCoordinatorFarmerPendingRegistration(String tokenNum) async {
    var list=await PendingUserListController.sendPendingRegistrationFarmerListForCoordinator(tokenNum);
    setState(() {
      farmerPendinglist=list!=null?list:[];
    }
    );
    return null;
  }

  @override
  void initState() {
  super.initState();
  fetchCities();
  }

  Future<List<String>> fetchCities() async{
    var citi= await PendingUserListController.fetchCities();
    setState(() {
      cities=citi;
    });
    print(cities);
  }
}