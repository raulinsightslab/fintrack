import 'dart:convert';

class TransactionModel {
  final int? id;
  final int userId;
  final String categoryId;
  final double amount;
  final DateTime date; // format yyyy-MM-dd
  final String note;
  final String type;

  TransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.note,
    required this.type,
  });

  // Convert ke Map (buat database) - PERBAIKAN DI SINI
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'categoryId': categoryId,
      'amount': amount,
      'date': date.toIso8601String(), // Convert DateTime to String
      'note': note,
      'type': type,
    };
  }

  // Convert dari Map (hasil query db) - PERBAIKAN DI SINI
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      categoryId: map['categoryId'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String), // Parse String to DateTime
      note: map['note'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
