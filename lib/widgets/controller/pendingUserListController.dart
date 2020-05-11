import 'dart:convert';

import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/exception/pendingListException.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/model/userinformation.dart';
import 'package:govidhyan_flutter/utils/httputil.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/controller/citiesController.dart';
import 'package:govidhyan_flutter/widgets/controller/userDataController.dart';
import 'package:http/http.dart';

class PendingUserListController{

  static List<Coordinator> getLocalPendingCoordinatorList(){
    List<Coordinator> listo = [];
    return listo;
  }

  static List<FarmerInformation> getLocalPendingFarmerList(){
    List<FarmerInformation> listo = [];
    return listo;
  }
  static var header = {'Content-Type': 'application/json'};
  static Future<List<Coordinator>> sendPendingApprovalCoordinatorListForAdmin() async {
    List<Coordinator> listo = [];
    try {
      print('sending request to $host_port');
      var r = await sendGetRequest("http://$host_port/$PendingApprovalcoordinatorListApi");
      print("before decode");
      print(r);
      var response=decodeHttpResponse(r,"pending_controller");
      if (response is List<dynamic>) {
        response.forEach((value){
          print('in lists');
          listo.add(Coordinator.objFromJsonFields(value));
        });
        return listo;
      } else {
        print(response);
        throw NetworkFailureException("Error retriving Coordinators");
      }
    }on NetworkFailureException catch(e){
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected Failure happned while retriving farmers");
    }
  }

  static Future<List<FarmerInformation>> sendPendingApprovalFarmerListForAdmin(String city) async{
    List<FarmerInformation> listo=[];
    try {
      var r = await sendGetRequest("http://$host_port/$PendingApprovalfarmerListCityApi?city=$city");
      var response=decodeHttpResponse(r,"pending_controller");
      if(response is List<dynamic>){
        response.forEach((value){
          listo.add(FarmerInformation.objFromJsonFields(value));
        });
           return listo;
      }else{
        print(response);
        throw NetworkFailureException("Error retriving Farmers");
      }
    }on NetworkFailureException catch(e){
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected Failure happned while retriving farmers");
    }
  }

  static Future<List<FarmerInformation>> sendPendingRegistrationFarmerListForAdmin(String city) async{
    List<FarmerInformation> listo=[];
    try {
      var r = await sendGetRequest("http://$host_port/$PendingRegistraionfarmerListCityApi?city=$city");
      var response=decodeHttpResponse(r,"pending_controller");
      if(response is List<dynamic>){
        response.forEach((value){
          listo.add(FarmerInformation.objFromJsonFields(value));
        });
        return listo;
      }else{
        print(response);
        throw NetworkFailureException("Error retriving Farmers");
      }
    }on NetworkFailureException catch(e){
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected Failure happned while retriving farmers");
    }
  }

  static Future<List<FarmerInformation>> sendPendingApprovalFarmerListForCoordinator(String tokenNum) async{
    List<FarmerInformation> listo=[];
    try {
      var r = await sendGetRequest("http://$host_port/$PendingApprovalcoordinatorFarmerListApi?tokenNum=$tokenNum");
      var response=decodeHttpResponse(r,"pending_controller");
      if(response is List<dynamic>){
        response.forEach((value){
          listo.add(FarmerInformation.objFromJsonFields(value));
        });
        return listo;
      }else{
        print(response);
        throw NetworkFailureException("Error retriving Farmers");
      }
    }on NetworkFailureException catch(e){
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected Failure happned while retriving farmers");
    }
  }

  static Future<List<FarmerInformation>> sendPendingRegistrationFarmerListForCoordinator(String tokenNum) async{
    List<FarmerInformation> listo=[];
    try {
      var r = await sendGetRequest("http://$host_port/$PendingRegistrationcoordinatorFarmerListApi?tokenNum=$tokenNum");
      var response=decodeHttpResponse(r,"pending_controller");
      if(response is List<dynamic>){
        response.forEach((value){
          listo.add(FarmerInformation.objFromJsonFields(value));
        });
        return listo;
      }else{
        print(response);
        throw NetworkFailureException("Error retriving Farmers");
      }
    }on NetworkFailureException catch(e){
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected Failure happned while retriving farmers");
    }
  }

  static Future<List> actOnUser(int position,List list,String type) async {
    //check except
    var result=false;

      if (type.contains("Farmer")) {
        print("in approve farmer flow");
        result=await approveRejectFarmer(list[position], type);
        _removeFromTable((list[position] as FarmerInformation).mobNumber, "Farmer");
        list.removeAt(position);
      } else {
        print("in approve coordinator flow");
        result=await approveRejectCoordinator(list[position], type);
        _removeFromTable((list[position] as Coordinator).mobNumber, "Coordinator");
        list.removeAt(position);
      }
    return list;
  }

  static Future<List<String>> fetchCities() async {
    return  await CityController.getCities();
  }

   static _removeFromTable(int mobNumber,String userType){

  }
  static Future<bool> approveRejectCoordinator(Coordinator coordinator,String type) async{
    var params={"tokenNum":coordinator.tokenNum,"token":coordinator.token,"cities":coordinator.cities,"name":coordinator.name,"mobNumber":coordinator.mobNumber};
    var header={'Content-Type':'application/json'};
    try {
      var r = await sendPostHeaderRequest("http://$host_port/${type=="Approve_Coordinator"?approveCoordinator:rejectCoordinator}?tokenNum=${UserData.user.tokenNum}", params, header, requestTimeout);
      var response = decodeHttpResponse(r,"pending_controller");
      if (response is Map<String, dynamic>) {}
      return true;
    } on PendingListException {
      rethrow;
    }on NetworkFailureException{
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected error happened while completing request.");
    }


  }

  static Future<bool> approveRejectFarmer(FarmerInformation farmer,String type) async{
    var params={"mobNumber":farmer.mobNumber,"city":farmer.city,"name":farmer.name};
    var header={'Content-Type':'application/json'};
    try {
      var r = await sendPostHeaderRequest("http://$host_port/${type=="Approve_Farmer"?approveFarmer:rejectFarmer}?tokenNum=${UserData.user.tokenNum}", params, header, requestTimeout);
      var response = decodeHttpResponse(r,"pending_controller");
      if (response is Map<String, dynamic>) {}
      return true;
    } on PendingListException {
      rethrow;
    }on NetworkFailureException{
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected error happened while completing request.");
    }
 }

}