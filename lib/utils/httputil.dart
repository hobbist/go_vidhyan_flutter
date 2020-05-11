import 'package:govidhyan_flutter/exception/citiNotFetchedException.dart';
import 'package:govidhyan_flutter/exception/loginException.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/exception/pendingListException.dart';
import 'package:govidhyan_flutter/exception/requestRegistrationException.dart';
import 'package:govidhyan_flutter/exception/signupException.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:http/http.dart';


dynamic sendGetRequest(String url) async {
  try {
    var response = await http.get(url).timeout(Duration(seconds: requestTimeout));
    return response;
  }catch(e){
    print('Error happened in http request $e');
    throw new Exception('Error happened in http request $e');
  }
}

Future<Response> sendGetRequestUpdated(String url) async {
  try {
    var response = await http.get(url).timeout(Duration(seconds: 10));
    return response;
  }catch(e){
    print('Error happened in http request $e');
    throw new NetworkFailureException('Error happened in http request $e');
  }
}

dynamic sendPostHeaderRequest(String url,Map<String,dynamic> bodyParam,Map<String,dynamic> header,int timeout) async {
  try {
    print(json.encode(bodyParam));
    var response = await http.post(
        url, body: json.encode(bodyParam), headers: header).timeout(
        Duration(seconds: timeout));
    return response;
  } catch (e) {
    print('Error happened in http request $e');
    throw new NetworkFailureException('Error happened in http request $e');
  }
}
 dynamic decodeHttpResponse(Response response, String controller){
    var r=json.decode(response.body);
    if(response.statusCode==200){
      return r;
    }else{
      if(r is Map<String,dynamic>){
        switch (controller){
          case "cities_controller":{
            print(r);
            if(r.containsKey("errorCode")){
              var err=r["errorCode"];
              throw CitiNotFetchedException("Unable to fetch Cities");
            }
          }
          break;
          case "login_controller":{
            if (r.containsKey("errorCode")) {
              print(r["errorCode"]);
              switch (r["errorCode"]) {
                case "LOGIN_FAILED":
                  {
                    throw LoginFailureException("Invalid Username/Password");
                  }
                  break;
                case "user_does_not_exists":
                  {
                    throw LoginFailureException("User is not registered in system");
                  }
                  break;
                default :
                  {
                    throw LoginFailureException("Unexpected error happened please try after some time.");
                  }
              }
            } else {
              throw LoginFailureException("Unexpected error happened please try after some time.");
            }
          }
          break;
          case "pending_controller":{
            if(r.containsKey("errorCode")){
              var err=r["errorCode"];
              switch (err){
                case "MISSING_REQUIRED_FIELD":{
                  throw PendingListException("Please check submitted fields");
                }
                break;
                case "COORDINATOR_APPROVAL_FAILED":{
                  throw PendingListException("Request for this user is already in progress");
                }
                break;
                case "COORDINATOR_REJECTION_FAILED":{
                  throw PendingListException("Request for this user is already in progress");
                }
                break;
                case "COORDINATOR_DELETION_FAILED":{
                  throw PendingListException("Request for this user is already in progress");
                }
                break;
                case "FARMER_APPROVAL_FAILED":{
                  throw PendingListException("Request for this user is already in progress");
                }
                break;
                case "FARMER_REJECTION_FAILED":{
                  throw PendingListException("Request for this user is already in progress");
                }
                break;
                case "FARMER_DELETION_FAILED":{
                  throw PendingListException("Request for this user is already in progress");
                }
                case "FARMER_ALREADY_REGISTERED":{
                  throw PendingListException.withCode("Already registered","FARMER_ALREADY_REGISTERED");
                }
                break;
                case "FARMER_ALREADY_APPROVED":{
                  throw PendingListException.withCode("Already registered","FARMER_ALREADY_APPROVED");
                }
                break;
                case "FARMER_ALREADY_REJECTED":{
                  throw PendingListException.withCode("Already registered","FARMER_ALREADY_REJECTED");
                }
                break;
                case "COORDINATOR_ALREADY_APPROVED":{
                  throw PendingListException.withCode("Already registered","COORDINATOR_ALREADY_APPROVED");
                }
                break;
                case "COORDINATOR_ALREADY_REJECTED":{
                  throw PendingListException.withCode("Already registered","COORDINATOR_ALREADY_REJECTED");
                }
                break;
                case "COORDINATOR_ALREADY_REGISTERED":{
                  throw PendingListException.withCode("Already registered","COORDINATOR_ALREADY_REGISTERED");
                }
                break;
                case "FARMER_NOT_FOUND":{
                  throw PendingListException.withCode("Already registered","NOT_FOUND");
                }
                break;
                default:{
                  throw PendingListException("Signup Not Complete");
                }
              }
            }
          }
          break;
          case "registration_controller" :{
            if(r.containsKey("errorCode")){
              var err=r["errorCode"];
              switch (err){
                case "FARMER_REGISTRATION_FAILED":{
                  throw RequestRegistrationException("Failed to Complete Request.Please try again.");
                }
                break;
                case "INTERNAL_SERVER_ERROR":{
                  throw NetworkFailureException("Unexpected Error happened");
                }
                break;
                default:{
                  throw RequestRegistrationException("UnExpected Error Happened");
                }
              }
            }
          }
          break;
          case "signup_controller":{
            if(r.containsKey("errorCode")){
              var err=r["errorCode"];
              var err_mgs=r["msg"];
              switch (err){
                case "MISSING_REQUIRED_FIELD":{
                  throw SignupException(err_mgs!=null?err_mgs:"Please check submitted fields");
                }
                break;
                case "COORDINATOR_REGISTRATION_FAILED":{
                  throw SignupException("Request for this user is already in progress");
                }
                break;
                default:{
                  throw SignupException("Signup Not Complete");
                }
              }
            }
          }
          break;
          case "map_cities_controller":{
            if(r.containsKey("errorCode")){
              var err=r["errorCode"];
              var err_mgs=r["msg"];
              switch (err){
                case "MISSING_REQUIRED_FIELD":{
                  throw NetworkFailureException(err_mgs!=null?err_mgs:"Please check submitted fields");
                }
                break;
                case "COORDINATOR_NOT_FOUND":{
                  throw NetworkFailureException("Coordinator Not Found in Database");
                }
                break;
                case "COORDINATOR_ALREADY_DELETED":{
                  throw NetworkFailureException("Coordinator Already deleted");
                }break;
                default:{
                  throw NetworkFailureException("Unexpected Exception happened");
                }
              }
            }
          }
        }
      }else{
        throw NetworkFailureException("Unexpected Error happened");
      }
    }
  }