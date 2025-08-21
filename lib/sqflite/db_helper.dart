import 'package:fintrack/model/chart_data.dart';
import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/model/user_register.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fintrack.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel users
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT,
            password TEXT
          )
        ''');

        // Tabel transactions
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            categoryId TEXT,
            amount REAL,
            date TEXT,
            note TEXT,
            type TEXT
          )
        ''');
      },
    );
  }

  //-------------- USERS --------------
  static Future<int> registerUser(Userregist user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  static Future<Userregist?> loginUser(String email, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return Userregist.fromMap(results.first);
    }
    return null;
  }

  //------------ TRANSACTIONS ------------
  static Future<int> addTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  static Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final results = await db.query('transactions', orderBy: 'date DESC');
    return results.map((map) => TransactionModel.fromMap(map)).toList();
  }

  static Future<List<TransactionModel>> getTransactionsByUserId(
    int userId,
  ) async {
    final db = await database;
    final results = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return results.map((map) => TransactionModel.fromMap(map)).toList();
  }

  static Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  static Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<double> getSaldo(int userId) async {
    final transactions = await getTransactionsByUserId(userId);
    double total = 0;

    for (var transaction in transactions) {
      if (transaction.type == 'Pemasukan') {
        total += transaction.amount;
      } else if (transaction.type == 'Pengeluaran') {
        total -= transaction.amount;
      }
    }
    return total;
  }

  static Future<Map<String, double>> getMonthlySummary(
    int userId,
    DateTime month,
  ) async {
    final transactions = await getTransactionsByUserId(userId);
    double pemasukan = 0;
    double pengeluaran = 0;

    for (var transaction in transactions) {
      final transactionDate = transaction.date;
      if (transactionDate.year == month.year &&
          transactionDate.month == month.month) {
        if (transaction.type == 'Pemasukan') {
          pemasukan += transaction.amount;
        } else {
          pengeluaran += transaction.amount;
        }
      }
    }
    return {
      'Pemasukan': pemasukan,
      'Pengeluaran': pengeluaran,
      'saldo': pemasukan - pengeluaran,
    };
  }

  //---------Chart_Data---------
  static Future<List<ChartData>> getChartData(
    int userId,
    DateTime month,
  ) async {
    final db = await database;

    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        userId,
        firstDay.toIso8601String(),
        lastDay.toIso8601String(),
      ],
    );

    // Kelompokkan data berdasarkan kategori dan jenis transaksi
    Map<String, double> categorySums = {};
    Map<String, String> categoryTypes = {};

    for (var map in maps) {
      final category = map['category_id'];
      final amount = map['amount'];
      final type = map['type'];

      if (categorySums.containsKey(category)) {
        categorySums[category] = categorySums[category]! + amount;
      } else {
        categorySums[category] = amount;
        categoryTypes[category] = type;
      }
    }

    // Konversi ke List<ChartData>
    return categorySums.entries.map((entry) {
      return ChartData(
        category: entry.key,
        amount: entry.value,
        type: categoryTypes[entry.key]!,
      );
    }).toList();
  }
}
