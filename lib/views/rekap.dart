import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/widget/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/chart_data.dart';

class RekapPage extends StatefulWidget {
  const RekapPage({super.key});
  static const id = "/rekap";

  @override
  State<RekapPage> createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  List<TransactionModel> transaksi = [];
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    getTransaction();
  }

  Future<void> getTransaction() async {
    final dataTransaction = await DbHelper.getAllTransactions();

    setState(() {
      transaksi = dataTransaction;

      // Konversi ke chartData
      chartData = transaksi.map((t) {
        return ChartData(
          category: t.categoryId,
          amount: t.amount,
          type: t.type, // "Pemasukan" / "Pengeluaran"
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total pemasukan & pengeluaran
    double totalIncome = chartData
        .where((c) => c.type == "Pemasukan")
        .fold(0, (sum, c) => sum + c.amount);

    double totalExpense = chartData
        .where((c) => c.type == "Pengeluaran")
        .fold(0, (sum, c) => sum + c.amount);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: const Text("Rekap Transaksi"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: transaksi.isEmpty
            ? Center(child: Text("Belum ada transaksi"))
            : Column(
                children: [
                  // ==== PIE CHART PEMASUKAN VS PENGELUARAN ====
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: AppColor.income,
                            value: totalIncome,
                            title: "Pemasukan\n${totalIncome.toInt()}",
                            radius: 80,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColor.expense,
                            value: totalExpense,
                            title: "Pengeluaran\n${totalExpense.toInt()}",
                            radius: 80,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transaksi.length,
                      itemBuilder: (context, index) {
                        final t = transaksi[index];
                        return ListTile(
                          leading: Icon(
                            t.type == "Pemasukan"
                                // ? Icons.arrow_downward
                                // : Icons.arrow_upward,
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: t.type == "Pemasukan"
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                            t.note.isNotEmpty ? t.note : t.categoryId,
                          ),
                          subtitle: Text(
                            '${t.date.day}/${t.date.month}/${t.date.year}',
                          ),
                          trailing: Text(
                            "Rp ${t.amount.toStringAsFixed(0)}",
                            style: TextStyle(
                              color: t.type == "Pemasukan"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
