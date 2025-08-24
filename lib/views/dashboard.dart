import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const id = "/dashboardpage";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<TransactionModel> transaksiList = [];
  double totalSaldo = 0;
  int currentUserId = 1;

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transaksi = await DbHelper.getTransactionsByUserId(currentUserId);
    final saldo = await DbHelper.getSaldo(currentUserId);

    if (mounted) {
      setState(() {
        transaksiList = transaksi;
        totalSaldo = saldo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      drawer: AppDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.textPrimary, // warna icon drawer jadi putih
        ),
        title: Text("Dompet", style: TextStyle(color: AppColor.textPrimary)),
        centerTitle: true,
        backgroundColor: AppColor.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // SALDO CARD
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: AppColor.kartuSaldo,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saldo Dompet",
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      formatCurrency.format(totalSaldo),
                      style: TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.account_balance_wallet,
                          color: AppColor.textPrimary,
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // RIWAYAT TRANSAKSI TERBARU
            Text(
              "Transaksi Terbaru",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: transaksiList.isEmpty
                  ? Center(
                      child: Text(
                        "Belum ada transaksi",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transaksiList.length,
                      itemBuilder: (context, index) {
                        final transaction = transaksiList[index];
                        return Card(
                          color: AppColor.surface,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              transaction.type == "Pemasukan"
                                  // ? Icons.arrow_downward
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              // : Icons.arrow_upward,
                              color: transaction.type == "Pemasukan"
                                  ? AppColor.income
                                  : AppColor.expense,
                            ),
                            title: Text(
                              transaction.note,
                              style: TextStyle(color: AppColor.textPrimary),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(transaction.date),
                              style: TextStyle(color: AppColor.textSecondary),
                            ),
                            trailing: Text(
                              formatCurrency.format(transaction.amount),
                              style: TextStyle(
                                color: transaction.type == "Pemasukan"
                                    ? AppColor.income
                                    : AppColor.expense,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_page').then((_) => _loadData());
        },
        backgroundColor: const Color(0xFF0A0F24),
        child: Icon(Icons.add, color: AppColor.textPrimary),
      ),
    );
  }
}
