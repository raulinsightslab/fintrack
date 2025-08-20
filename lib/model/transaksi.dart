class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type; // "income" / "expense"
  final String date; // bisa simpan String, format yyyy-MM-dd

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  // Convert ke Map (buat database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }

  // Convert dari Map (hasil query db)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      date: map['date'],
    );
  }
}
