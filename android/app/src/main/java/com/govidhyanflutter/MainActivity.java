package com.govidhyanflutter;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.telephony.SmsManager;
import android.util.Log;


import java.net.URLEncoder;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "sendSms";

  private MethodChannel.Result callResult;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    final Context context=getBaseContext();
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if(call.method.equals("send")){
                  String num = call.argument("phone");
                  String msg = call.argument("msg");
                  sendSMS(num,msg,result);
                }else if (call.method.equals("whatsapp")){
                  whatsApp(call.argument("phone").toString(),call.argument("msg").toString(),result,context);
                  //result.notImplemented();
                }
                else{
                  result.notImplemented();
                }
              }
            });
  }

  private void sendSMS(String phoneNo, String msg,MethodChannel.Result result) {
    try {
      SmsManager smsManager = SmsManager.getDefault();
      smsManager.sendTextMessage(phoneNo, null, msg, null, null);
      result.success("SMS Sent");
    } catch (Exception ex) {
      ex.printStackTrace();
      result.error("Err","Sms Not Sent","");
    }
  }

  private void whatsApp(String phoneNo,String msg,MethodChannel.Result result,Context context){
      PackageManager packageManager = context.getPackageManager();
      Intent i = new Intent(Intent.ACTION_VIEW);

      try {
        String url = "https://api.whatsapp.com/send?phone="+ phoneNo +"&text=" + URLEncoder.encode(msg, "UTF-8");
        i.setPackage("com.whatsapp");
        i.setData(Uri.parse(url));
        if (i.resolveActivity(packageManager) != null) {
          context.startActivity(i);
        }
      } catch (Exception e){
        e.printStackTrace();
      }
  }
}
