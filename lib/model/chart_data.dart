// lib/model/chart_data.dart
class ChartData {
  final String category;
  final double amount;
  final String type;

  ChartData({required this.category, required this.amount, required this.type});

  // Optional: Method untuk konversi dari Map (jika diperlukan)
  factory ChartData.fromMap(Map<String, dynamic> map) {
    return ChartData(
      category: map['category'].toString(),
      amount: double.parse(map['amount'].toString()),
      type: map['type'].toString(),
    );
  }

  // Optional: Method untuk konversi ke Map (jika diperlukan)
  Map<String, dynamic> toMap() {
    return {'category': category, 'amount': amount, 'type': type};
  }
}
