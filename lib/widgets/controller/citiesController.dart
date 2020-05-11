import 'package:govidhyan_flutter/exception/citiNotFetchedException.dart';
import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/utils/httputil.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';

class CityController{
  static Future<List<String>> getCities() async{
    try{
    //check if cities are updated on current date if yes
    List<String> cities=[];
    var response=await sendGetRequestUpdated("http://$host_port/$getAllCities");
     var r= decodeHttpResponse(response,"cities_controller");
     if(r is List<dynamic>) {
       (r as List<dynamic>).forEach((value) {
         Map<String,dynamic> city=value;
         cities.add(city['name']);
       });
       return cities;
     }
    return cities;
    }on Exception catch(e){
      print("Exception type is ${e.runtimeType}");
      throw new NetworkFailureException("Unable to fetch Cities");
    }
  }
}