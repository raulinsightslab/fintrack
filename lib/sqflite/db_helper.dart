import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/model/user_register.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//  await db.execute('''
// //           CREATE TABLE transactions(
// //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// //             userId INTEGER,
// //             categoryId INTEGER,
// //             amount REAL,
// //             date TEXT,
// //             note TEXT,
// //             FOREIGN KEY (userId) REFERENCES userregist (id),
// //             FOREIGN KEY (categoryId) REFERENCES categories (id)
// //           )
// //         ''');
// //       },
// //     );
// //   }

class DbHelper {
  static Future<Database> databaseHelper() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'login.db'),
      onCreate: (db, version) async {
        //tabel buat user
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, email TEXT, password TEXT)',
        );
        //tabel buat transaction
        await db.execute('''
        CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            categoryId TEXT,
            amount REAL,
            date TEXT,
            note TEXT,
            type TEXT,
            FOREIGN KEY (userId) REFERENCES userregist (id),
            FOREIGN KEY (categoryId) REFERENCES categories (id)
          )
        ''');
      },
      version: 1,
    );
  }

  //--------------users-------------
  static Future<void> registerUser(Userregist user) async {
    final db = await databaseHelper();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Userregist?> loginUser(String email, String password) async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
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

  //------------transaction-------------
  static Future<int> addTransaction(TransactionModel transaction) async {
    final db = await databaseHelper();
    return await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // static Future<List>TransactionModel>> getAllTransaction() async{
  static Future<List<TransactionModel>> getAllTransaction() async {
    final db = await databaseHelper();
    final List<Map<String, dynamic>> results = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return results.map((map) => TransactionModel.fromMap(map)).toList();
  }

  static Future<double> getSaldo() async {
    final List<TransactionModel> allTransaction = await getAllTransaction();
    double total = 0;
    for (var transaction in allTransaction) {
      if (transaction.type == 'Pemasukkan') {
        total += transaction.amount;
      } else if (transaction.type == 'Pengeluaran') {
        total -= transaction.amount;
      }
    }
    return total;
  }
}
