import 'dart:convert';

import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/exception/requestRegistrationException.dart';
import 'package:govidhyan_flutter/model/userinformation.dart';
import 'package:govidhyan_flutter/utils/sms.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';
import 'package:govidhyan_flutter/widgets/controller/citiesController.dart';
import 'package:govidhyan_flutter/widgets/controller/userDataController.dart';
import 'package:govidhyan_flutter/utils/httputil.dart';
import 'package:http/http.dart';
class RegistrationController{
  void sendRegistration(FarmerInformation userInformation) async  {
      //TODO --prepare userspecifi link
    try{
    List<String> recipients=[userInformation.mobNumber.toString()];
    print(userInformation.city);
    String message= sms_message_text.replaceAll("farmer_name", userInformation.name).replaceAll("mob_number", userInformation.mobNumber.toString())+createPersonalizedLink(userInformation);
    if(await checkRegistration(userInformation)) {
      SmsUtil.sendSMS(message, recipients);
   }else{
      //display error response
      print(" Registration Controller Should not come in this condition");
   }
    }on RequestRegistrationException {
      rethrow;
    }on NetworkFailureException{
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected error happened while completing request.");
    }

  }
Future<bool> checkRegistration(FarmerInformation userInformation) async{
    var params={"name":userInformation.name,"city":userInformation.city,"tokenNum":userInformation.tokenNum};
    var header={'Content-Type':'application/json'};
    try {
      var r = await sendPostHeaderRequest("http://$host_port/$requestFarmerRegistrationApi?tokenNum=${UserData.user.tokenNum}", params, header, requestTimeout);
      var response = decodeHttpResponse(r,"registration_controller");
      return true;
    } on RequestRegistrationException {
      rethrow;
    }on NetworkFailureException{
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected error happened while completing request.");
    }
  }



  Future<List<String>> fetchCities(){
    try {
      var cities = CityController.getCities();
      return cities;
    }on Exception{
      rethrow;
    }
  }

  String createPersonalizedLink(FarmerInformation farmer){
    return goVidhnyanUrl+"/"+registerFamer+"?tokenNum=${farmer.tokenNum}";

  }
}