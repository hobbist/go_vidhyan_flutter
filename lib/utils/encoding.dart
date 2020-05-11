import 'dart:convert';
String getEncodedString(String str){
  if(str!=null){
    return base64.encode(utf8.encode(str));
  }else{
    return "";
  }
}