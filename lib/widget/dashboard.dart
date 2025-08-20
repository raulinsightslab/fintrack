import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static const id = "/dashboard";

  @override
  Widget build(BuildContext context) {
    // Dummy data sementara
    double totalSaldo = 5000000;
    double totalPemasukan = 7500000;
    double totalPengeluaran = 2500000;

    List<Map<String, dynamic>> transaksi = [
      {"judul": "Makan Siang", "jumlah": -50000, "tanggal": "18-08-2025"},
      {"judul": "Gaji Bulanan", "jumlah": 7000000, "tanggal": "01-08-2025"},
      {"judul": "Belanja Bulanan", "jumlah": -1500000, "tanggal": "05-08-2025"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0F24),
                ),
              ),
              const SizedBox(height: 20),

              // Card saldo
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Saldo",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Rp ${totalSaldo.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ringkasan pemasukan & pengeluaran
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Pemasukan",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rp ${totalPemasukan.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Pengeluaran",
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rp ${totalPengeluaran.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // List transaksi terbaru
              const Text(
                "Transaksi Terbaru",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: transaksi.map((trx) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        trx["jumlah"] > 0
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: trx["jumlah"] > 0 ? Colors.green : Colors.red,
                      ),
                      title: Text(trx["judul"]),
                      subtitle: Text(trx["tanggal"]),
                      trailing: Text(
                        "Rp ${trx["jumlah"].toStringAsFixed(0)}",
                        style: TextStyle(
                          color: trx["jumlah"] > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
