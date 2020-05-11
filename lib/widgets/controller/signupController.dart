import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/exception/signupException.dart';
import 'package:govidhyan_flutter/model/city.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/utils/httputil.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';
import 'package:govidhyan_flutter/widgets/controller/citiesController.dart';

class SignupController{

   Future<List<String>> fetchCities(){
     return CityController.getCities();
  }

    Future<Coordinator> senRegistrationRequest(Coordinator coordinator) async {
     var params={"tokenNum":coordinator.tokenNum,"token":coordinator.token,"cities":City.toJsonMap(coordinator.cities),"name":coordinator.name,"mobNumber":coordinator.mobNumber,"address":coordinator.address};
     print(params);
     var header={'Content-Type':'application/json'};
     try {

       var r = await sendPostHeaderRequest("http://$host_port/$singup", params, header, requestTimeout);
       var response = decodeHttpResponse(r,"signup_controller");
       if (response is Map<String, dynamic>) {
         var status = response["status"];
         coordinator.status = status;
       }
       return coordinator;
     } on SignupException {
       rethrow;
     }on NetworkFailureException{
        rethrow;
     }on Exception{
       throw NetworkFailureException("Unexpected error happened while completing request.");
     }
   }

   validatePassword(value){
     RegExp exp = new RegExp(r"^[a-z]*[A-Z][0-9]+$");
     if(value.length<6||value.length>12){
       return password_length_validation;
     }

   }

   validateFarmerName(value){
     if(value.length>50 || value.length<5){
       return farmer_name_validation;
     }
   }

   validateMobileNumber(value){
     if(value.length>12 || value.length<10){
       return mobile_number_validation;
     }
   }
   validateAddress(String value) {
     if(value.length>100 || value.length<5){
       return mobile_number_validation;
     }
   }
}