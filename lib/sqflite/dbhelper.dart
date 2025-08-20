import 'dart:async';
import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/model/user_register.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _db;



  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "fintrack.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tabel user
        await db.execute('''
          CREATE TABLE userregist(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');

        // // Tabel kategori
        // await db.execute('''
        //   CREATE TABLE categories(
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     name TEXT,
        //     type TEXT 
        //   )
        // ''');

        // Tabel transaksi
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            categoryId INTEGER,
            amount REAL,
            date TEXT,
            note TEXT,
            FOREIGN KEY (userId) REFERENCES userregist (id),
            FOREIGN KEY (categoryId) REFERENCES categories (id)
          )
        ''');
      },
    );
  }

  // ---------------- USER ----------------
  Future<int> insertUser(Userregist user) async {
    final dbClient = await db;
    return await dbClient.insert("userregist", user.toMap());
  }

  Future<List<Userregist>> getUsers() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query(
      "userregist",
    );
    return result.map((map) => Userregist.fromMap(map)).toList();
  }

  Future<Userregist?> getUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query(
      "userregist",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return Userregist.fromMap(result.first);
    }
    return null;
  }

  // // ---------------- CATEGORY ----------------
  // Future<int> insertCategory(Category category) async {
  //   final dbClient = await db;
  //   return await dbClient.insert("categories", category.toMap());
  // }

  // Future<List<Category>> getCategories() async {
  //   final dbClient = await db;
  //   final List<Map<String, dynamic>> result = await dbClient.query(
  //     "categories",
  //   );
  //   return result.map((map) => Category.fromMap(map)).toList();
  }

  // ---------------- TRANSACTION ----------------
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await ;
    return await dbClient.insert("transactions", trx.toMap());
  }

  Future<List<MyTransaction.Transaction>> getTransactions() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query(
      "transactions",
      orderBy: "date DESC",
    );
    return result.map((map) => MyTransaction.Transaction.fromMap(map)).toList();
  }
}
