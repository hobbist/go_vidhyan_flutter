import 'dart:convert';

import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/model/action.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/model/role.dart';
import 'package:govidhyan_flutter/utils/httputil.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/exception/loginException.dart';
import 'package:govidhyan_flutter/widgets/constants/messages.dart';
import 'package:http/http.dart';

class LoginController{

  static Future<Coordinator> sendLoginRequest(Coordinator coordinator) async{
   //return  Future.delayed(const Duration(seconds: 3),()=>returnFakeCoordinator(coordinator));
    try {
      print(coordinator.tokenNum);
      var params={'tokenNum':coordinator.tokenNum,'token':coordinator.token};
      var header={'Content-Type':'application/json'};
      print('sending request to $host_port');
      var r = await sendPostHeaderRequest("http://$host_port/$loginApi",params,header,requestTimeout);
      var response=decodeHttpResponse(r,"login_controller");
      print(response.toString());
      coordinator.fromJsonFields(response);
      print(coordinator.toString());
      //before sending back to user insert this into local table
      return coordinator;
    }on LoginFailureException{
      rethrow;
    }on Exception{
      throw NetworkFailureException("Unexpected Failure happened");
    }
  }

   static Coordinator returnFakeCoordinator(Coordinator coordinator){
    var r=Role();
    r.actions=[Action.withName("pending_registration", ""),Action.withName("send_registration", ""),Action.withName("check_stages","")];
    r.name="admin";
    coordinator.role=r;
    return coordinator;
  }
   dynamic validatePassword(value){
      if(value.length<4 || value.length>12){
        return password_length_validation;
      }
    }

    dynamic validateUserId(value){
      RegExp exp = new RegExp(r"^[0-9]+$");
      if(!exp.hasMatch(value)||(value.length>12 || value.length<10)){
        return user_id_validation;
      }
    }
}