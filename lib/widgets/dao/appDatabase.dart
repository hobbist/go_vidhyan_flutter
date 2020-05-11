import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:govidhyan_flutter/widgets/constants/database.dart';

class AppDataBaseHelper{
  AppDataBaseHelper._();
  static final AppDataBaseHelper db=AppDataBaseHelper._();
  Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "govidhyan.db");
    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute(create_pending_users);
      await db.execute(create_coordinator);
    });
  }
}