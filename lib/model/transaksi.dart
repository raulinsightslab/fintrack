// id INTEGER PRIMARY KEY AUTOINCREMENT,
//             userId INTEGER,
//             categoryId INTEGER,
//             amount REAL,
//             date TEXT,
//             note TEXT,
//             FOREIGN KEY (userId) REFERENCES userregist (id),
//             FOREIGN KEY (categoryId) REFERENCES categories (id)

import 'dart:convert';
// await db.execute(
//           'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,amount TEXT,type TEXT,date TEXT)',
//         );

class TransactionModel {
  final int? id;
  final int userId;
  final String categoryId;
  final double amount;
  final String date; // format yyyy-MM-dd
  final String note;

  TransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.note,
  });

  // Convert ke Map (buat database)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'categoryId': categoryId,
      'amount': amount,
      'date': date,
      'note': note,
    };
  }

  // Convert dari Map (hasil query db)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['userId'],
      categoryId: map['categoryId'],
      amount: map['amount'],
      date: map['date'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromjJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
