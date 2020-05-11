import 'package:govidhyan_flutter/exception/networkexception.dart';
import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/utils/httputil.dart';
import 'package:govidhyan_flutter/widgets/constants/constants.dart';
import 'package:govidhyan_flutter/widgets/controller/citiesController.dart';
import 'package:govidhyan_flutter/widgets/controller/userDataController.dart';

class MapCoordinatorToCityController{
    Future<List> fetchCitiesFromQuery(String query,List<String> cities) async {
     await Future.delayed(Duration(milliseconds: 400), null);
     List<dynamic> tagList = <dynamic>[];
     int val=0;
     //get cities from cities list controller
     cities.forEach((String str)
     {
       val=val+1;
       tagList.add({'name':str,'value':val});

     });
     List<dynamic> filteredTagList = <dynamic>[];
     if (query.isNotEmpty) {
       filteredTagList.add({'name': query, 'value': 0});
     }
     for (var tag in tagList) {
       if (tag['name'].toLowerCase().contains(query.toLowerCase())) {
         filteredTagList.add(tag);
       }
     }
     return filteredTagList;
   }
   Future<List<Coordinator>> fetchCoordinators() async {
     List<Coordinator> listo = [];
     try {
       print('sending request to $host_port');
       var r = await sendGetRequest("http://$host_port/$getApprovedCoordinators");
       print("before decode");
       print(r);
       var response=decodeHttpResponse(r,"map_cities_controller");
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
       throw NetworkFailureException("Unexpected Failure happned while Fetching Coordinators");
     }

}
Future<List<String>> fetchCities(){
  return CityController.getCities();
}

Future<bool> mapCoordinatorToCities(Coordinator coordinator,List<dynamic> cities) async{
  try {
    var cString="";
    cities.forEach((str){cString=cString+"${str['name']},";});
    var params={'tokenNum':coordinator.tokenNum,'updatedBy':UserData.user.tokenNum,'cities':cString.substring(0,cString.length-1)};
    print(params);
    var header={'Content-Type':'application/json'};
    var r = await sendPostHeaderRequest("http://$host_port/$assignCitiesToCoordinator?updatedBy=${UserData.user.tokenNum}&tokenNum=${coordinator.tokenNum}&cities=$cString",params,header,requestTimeout);
    print("before decode");
    var response=decodeHttpResponse(r,"map_cities_controller");
    if (response is Map<String,dynamic>) {
      return true;
    } else {
      print(response);
      throw NetworkFailureException("Error Mapping Coordinator to Cities");
    }
  }on NetworkFailureException catch(e){
    rethrow;
  }on Exception{
    throw NetworkFailureException("Unexpected Failure happned while Fetching Coordinators");
  }
}
}