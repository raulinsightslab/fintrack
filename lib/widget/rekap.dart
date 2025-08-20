import 'package:flutter/material.dart';

class RekapPage extends StatelessWidget {
  const RekapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data pengeluaran & pemasukan
    final totalPemasukan = 7000000;
    final totalPengeluaran = 2000000;
    final saldo = totalPemasukan - totalPengeluaran;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap Keuangan'),
        backgroundColor: const Color(0xFF0A0F24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan saldo
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Saat Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp $saldo',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pemasukan: Rp $totalPemasukan   Pengeluaran: Rp $totalPengeluaran',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistik sederhana
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Statistik Bulanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Bulan Januari: Pemasukan Rp 1.000.000, Pengeluaran Rp 500.000',
                    ),
                    Text(
                      '• Bulan Februari: Pemasukan Rp 1.200.000, Pengeluaran Rp 700.000',
                    ),
                    Text(
                      '• Bulan Maret: Pemasukan Rp 900.000, Pengeluaran Rp 400.000',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
