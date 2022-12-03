// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';
// import 'category.dart';

// class SQLHelperCategory {

//   static Future<void> createCategoryTable(Database database) async {
//     await database.execute('''CREATE TABLE categories(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         category TEXT,
//         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//         )''');
//   }

//   static Future<Database> dbCategory() async {
//     return openDatabase(
//       'demo.dbCategory',
//       version: 1,
//       onCreate: (Database database, int version) async{
//         await createCategoryTable(database);
//       },
//     );
//   }

//   //Create new item
//   static Future<int> createCategory(Category category) async {
//     final dbCategory = await SQLHelperCategory.dbCategory();
//     final id = await dbCategory.insert('categories', category.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);

//     return id;
//   }

//   //Read
//   static Future<List<Map<String, dynamic>>> getCategorys() async {
//     final dbCategory = await SQLHelperCategory.dbCategory();
//     return dbCategory.query('categories', orderBy: "id");
//   }

//   //Update
//   static Future<int> updateCategory(Category category) async {
//     final dbCategory = await SQLHelperCategory.dbCategory();

//     final result =await dbCategory.update('categories', category.toMap(), where:  "id = ?", whereArgs: [category.id]);
//     return result;
//   }

//   //Delete
//   static Future<void> deleteCategory(int id) async {
//     final dbCategory =await SQLHelperCategory.dbCategory();

//     try{
//       await dbCategory.delete("categories", where: "id = ?", whereArgs: [id]);
//     } catch(err){
//       debugPrint("Something went wrong when deleting an category: $err");
//     }
//   }
// }