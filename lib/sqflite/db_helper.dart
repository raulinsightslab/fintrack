import 'package:fintrack/model/user_register.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> databaseHelper() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'login.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,nama TEXT, email TEXT,password TEXT)',
        );
        await db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,amount TEXT,type TEXT,date TEXT)',
        );
      },
      version: 1,
    );
  }

  //--------------users-------------
  static Future<void> RegisterUser(Userregist user) async {
    final db = await databaseHelper();
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Userregist?> loginUser(String email, String password) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return Userregist.fromMap(results.first);
    }
    return null;
  }

  static Future<void> updateUser(Userregist user) async {
    final db = await databaseHelper();
    await db.update(
      'users',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteUser(int id) async {
    final db = await databaseHelper();
    await db.delete('users', where: "id = ?", whereArgs: [id]);
  }
}
