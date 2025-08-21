import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
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
  int currentUserId = 1; // Ganti dengan ID user yang login

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
      appBar: AppBar(
        title: const Text("Dompet"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A0F24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // SALDO CARD
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Saldo Dompet",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatCurrency.format(totalSaldo),
                      style: const TextStyle(
                        color: Colors.white,
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
                          color: Colors.white70,
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
            const Text(
              "Transaksi Terbaru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: transaksiList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada transaksi",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transaksiList.length,
                      itemBuilder: (context, index) {
                        final transaction = transaksiList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              transaction.type == "Pemasukan"
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type == "Pemasukan"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(transaction.note),
                            subtitle: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(transaction.date),
                            ),
                            trailing: Text(
                              formatCurrency.format(transaction.amount),
                              style: TextStyle(
                                color: transaction.type == "Pemasukan"
                                    ? Colors.green
                                    : Colors.red,
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
