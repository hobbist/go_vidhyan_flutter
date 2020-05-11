import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:sms/sms.dart';
import 'package:flutter_sms/flutter_sms.dart';
class SmsUtil {
  SmsUtil(this.platform);
  MethodChannel platform=null;

  static void sendSMS(String message, List<String> recipents,{BuildContext context}) async {
    //TODO- handle error interms of alert box or dialog box
    //TODO- handle Sueccess interms of alert box or dialog box
    SmsSender sender=SmsSender();
    var messageObj=SmsMessage(recipents[0], message);
    messageObj.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }else if(state==SmsMessageState.Fail){
        print("SMS sending is failed");
        throw NetworkFailureException("failed to send sms to $recipents");
      }
    });
    sender.sendSms(SmsMessage(recipents[0], message));
  }


  Future<Null> sendSms(String message,List<String> recipeint) async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod('send',
          <String, dynamic>{
            "phone": recipeint[0],
            "msg": message
          }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static Future<String> sendSMSFlutter(String message, List<String> recipents,{BuildContext context}) async {
    String _result = await FlutterSms
        .sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
      return onError;
    });
    return _result;
  }
}