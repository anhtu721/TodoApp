// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';
// import 'status.dart';

// class SQLHelperStatus {

//   static Future<void> createStatusTable(Database database) async {
//     await database.execute('''CREATE TABLE statuses(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         status TEXT,
//         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//         )''');
        
//   }

//   static Future<Database> dbStatus() async {
//     return openDatabase(
//       'demo.dbStatus',
//       version: 1,
//       onCreate: (Database database, int version) async{
//         await createStatusTable(database);
//       },
//     );
//   }

//   //Create new item
//   static Future<int> createStatus(Status status) async {
//     final dbStatus = await SQLHelperStatus.dbStatus();
//     final id = await dbStatus.insert('statuses', status.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);

//     return id;
//   }

//   //Read
//   static Future<List<Map<String, dynamic>>> getStatuses() async {
//     final dbStatus = await SQLHelperStatus.dbStatus();
//     return dbStatus.query('statuses', orderBy: "id");
//   }

//   //Update
//   static Future<int> updateStatus(Status status) async {
//     final dbStatus = await SQLHelperStatus.dbStatus();

//     final result =await dbStatus.update('statuses', status.toMap(), where:  "id = ?", whereArgs: [status.id]);
//     return result;
//   }

//   //Delete
//   static Future<void> deleteStatus(int id) async {
//     final dbStatus =await SQLHelperStatus.dbStatus();

//     try{
//       await dbStatus.delete("statuses", where: "id = ?", whereArgs: [id]);
//     } catch(err){
//       debugPrint("Something went wrong when deleting an category: $err");
//     }
//   }
// }