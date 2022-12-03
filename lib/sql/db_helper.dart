import 'package:flutter/material.dart';
import 'package:notes_application/sql/items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createAccountTable(Database database) async {
    await database.execute('''CREATE TABLE accounts(
      uid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      email TEXT,
      password TEXT,
      firstName TEXT,
      lastName TEXT,
      createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
    await database.execute('''CREATE TABLE categories(
        idCate INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        category TEXT,
        email TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
    await database.execute('''CREATE TABLE priorities(
        idPriority INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        priority TEXT,
        email TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
    await database.execute('''CREATE TABLE statuses(
        idStatus INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        status TEXT,
        email TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
    await database.execute('''CREATE TABLE notes(
        idNote INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        noteName TEXT,
        category TEXT,
        priority TEXT,
        status TEXT,
        date TEXT,
        email TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
  }

  static Future<Database> db() async {
    return openDatabase('test.db', version: 1,
        onCreate: (Database database, int version) async {
      await createAccountTable(database);
    });
  }

// account
  // create item
  static Future<int> createAccount(Account account) async {
    final db = await SQLHelper.db();
    final uid = await db.insert('accounts', account.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return uid;
  }

  //read all items
  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await SQLHelper.db();
    return db.query('accounts');
  }

  // read a single item by id
  static Future<List<Map<String, dynamic>>> checkAccount(
      Account account) async {
    final db = await SQLHelper.db();
    return db.query('accounts',
        where: 'email = ? AND password = ?',
        whereArgs: [account.email, account.password],
        limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getEmail(String email) async {
    final db = await SQLHelper.db();
    return db.query('accounts',
        where: 'email = ?', whereArgs: [email], limit: 1);
  }

  // update an item by id
  static Future<int> updateAccount(Account account) async {
    final dbAccounts = await SQLHelper.db();
    final result = await dbAccounts.update('accounts', account.toMap(),
        where: 'uid = ?', whereArgs: [account.uid]);
    return result;
  }

// category
  //Create new item
  static Future<int> createCategory(Category category) async {
    final dbCategory = await SQLHelper.db();
    final idCate = await dbCategory.insert('categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return idCate;
  }

  //Read
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final dbCategory = await SQLHelper.db();
    return dbCategory.query('categories', orderBy: "idCate");
  }

  //Read all category items List-> obj
  static Future<List<Category>> getAllCategories() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> allCategoryRows = await db.query('categories');
    List<Category> categories =
    allCategoryRows.map((categoryTable) => Category.fromMap(categoryTable)).toList();
    return categories;
  }

  //Update
  static Future<int> updateCategory(Category category) async {
    final dbCategory = await SQLHelper.db();

    final result = await dbCategory.update('categories', category.toMap(),
        where: "idCate = ?", whereArgs: [category.idCate]);
    return result;
  }

  //Delete
  static Future<void> deleteCategory(int idCate) async {
    final dbCategory = await SQLHelper.db();

    try {
      await dbCategory
          .delete("categories", where: "idCate = ?", whereArgs: [idCate]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an category: $err");
    }
  }

  //priority

  //Create new item
  static Future<int> createPriority(Priority priority) async {
    final dbPriority = await SQLHelper.db();
    final idPriority = await dbPriority.insert('priorities', priority.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return idPriority;
  }

  //Read
  static Future<List<Map<String, dynamic>>> getPriorities() async {
    final dbPriority = await SQLHelper.db();
    return dbPriority.query('priorities', orderBy: "idPriority");
  }

  //Read all priority items List-> obj
  static Future<List<Priority>> getAllPriorities() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> allPriorityRows = await db.query('priorities');
    List<Priority> priorities =
    allPriorityRows.map((priorityTable) => Priority.fromMap(priorityTable)).toList();
    return priorities;
  }

  //Update
  static Future<int> updatePriority(Priority priority) async {
    final dbPriority = await SQLHelper.db();

    final result = await dbPriority.update('priorities', priority.toMap(),
        where: "idPriority = ?", whereArgs: [priority.idPriority]);
    return result;
  }

  //Delete
  static Future<void> deletePriority(int idPriority) async {
    final dbPriority = await SQLHelper.db();

    try {
      await dbPriority.delete("priorities",
          where: "idPriority = ?", whereArgs: [idPriority]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an category: $err");
    }
  }
  //Status

  static Future<int> createStatus(Status status) async {
    final dbStatus = await SQLHelper.db();
    final idStatus = await dbStatus.insert('statuses', status.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return idStatus;
  }

  //Read
  static Future<List<Map<String, dynamic>>> getStatuses() async {
    final dbStatus = await SQLHelper.db();
    return dbStatus.query('statuses', orderBy: "idStatus");
  }

  //Read all status items List-> obj
  static Future<List<Status>> getAllStatus() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> allStatusRows = await db.query('statuses');
    List<Status> status =
    allStatusRows.map((statusTable) => Status.fromMap(statusTable)).toList();
    return status;
  }

  //Update
  static Future<int> updateStatus(Status status) async {
    final dbStatus = await SQLHelper.db();

    final result = await dbStatus.update('statuses', status.toMap(),
        where: "idStatus = ?", whereArgs: [status.idStatus]);
    return result;
  }

  //Delete
  static Future<void> deleteStatus(int idStatus) async {
    final dbStatus = await SQLHelper.db();

    try {
      await dbStatus
          .delete("statuses", where: "idStatus = ?", whereArgs: [idStatus]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an category: $err");
    }
  }

  //notes
  static Future<int> createNote(Note note) async {
    final db = await SQLHelper.db();
    final id = await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //Read
  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SQLHelper.db();
    return db.query('notes', orderBy: "idNote");
  }

  //Read all note items List-> obj
  static Future<List<Note>> getAllNotes() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> allNoteRows = await db.query('notes');
    List<Note> note =
    allNoteRows.map((note) => Note.fromMap(note)).toList();
    return note;
  }

  //Update
  static Future<int> updateNote(Note note) async {
    final db = await SQLHelper.db();

    final result = await db.update('notes', note.toMap(),
        where: "idNote = ?", whereArgs: [note.idNote]);
    return result;
  }

  //count
  static Future<List<Map<String, dynamic>>> countNoteStatusPending() async {
    final db = await SQLHelper.db();
    var res = await db.rawQuery("""
      SELECT count(*) as count FROM notes WHERE status = 'Pending'
    """);
    return res;
  }

    static Future<List<Map<String, dynamic>>> countNoteStatusDone() async {
    final db = await SQLHelper.db();
    var res = await db.rawQuery("""
      SELECT count(*) as count FROM statuses WHERE status = 'Done'
    """);
    return res;
  }
    static Future<List<Map<String, dynamic>>> countNoteStatusProcessing() async {
    final db = await SQLHelper.db();
    var res = await db.rawQuery("""
      SELECT count(*) as count FROM statuses WHERE status = 'Processing'
    """);
    return res;
  }

  //Delete
  static Future<void> deleteNote(int idNote) async {
    final dbNote = await SQLHelper.db();

    try {
      await dbNote.delete("notes", where: "idNote = ?", whereArgs: [idNote]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an category: $err");
    }
  }
}
