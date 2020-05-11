import 'package:govidhyan_flutter/utils/encoding.dart';

class FarmerInformation{
  String _name;
  int _mobNumber;
  String _tokenNum;
  String _city;
  String get city=>_city;
  set city(String city)=>_city=city;
  String get name => _name;
  int _framSize;
  FarmerInformation(this._mobNumber,this._name){
    this._tokenNum=getEncodedString(this._mobNumber.toString());
  }
  FarmerInformation.withCity(this._name,this._mobNumber,this._city){
    this._tokenNum=getEncodedString(this._mobNumber.toString());
  }
  set name(String name) =>_name = name;
  int get mobNumber => _mobNumber;
  set mobNumber(int mobileNumber) => _mobNumber = mobileNumber;
  int get framSize => _framSize;
  set framSize(int framSize) =>_framSize = framSize;
  String get tokenNum => _tokenNum;

  set tokenNum(String value) {
    _tokenNum = value;
  }
  static FarmerInformation objFromJsonFields(Map<String,dynamic> json) {
    FarmerInformation farmer=FarmerInformation(int.parse(json['mobNumber']?.toString()) ,json['token'] as String);
    farmer.city=json['city'];
    farmer.name=json['name'];
    return farmer;
  }


}