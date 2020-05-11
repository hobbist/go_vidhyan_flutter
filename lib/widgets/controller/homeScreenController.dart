import 'package:govidhyan_flutter/model/coordinator.dart';
import 'package:govidhyan_flutter/widgets/dao/appDatabase.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeScreenController{
  static getCoordinatorFromLocalDB(){
    return
      AppDataBaseHelper.db.database.then((dbd){
      return dbd.rawQuery("select * from coordinator").then((values){
        if(values.length==1) {
          return Coordinator.objFromJsonFields(values[0]);
        }else
          {
            return null;
          }
      });
    });
    //check local db if coordinator is present.if not send null
    return Coordinator(1234567890,"testData");
  }
  static addCoordinatorToLocalDb(Coordinator coordinator){
    AppDataBaseHelper.db.database.then((dbd){
      //dbd.execute("insert into coordinator",coordinator.toMap());
    });
  }
}