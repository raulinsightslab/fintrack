import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedType = "income";
  DateTime _selectedDate = DateTime.now();

  List<TransactionModel> _transactions = [];

  // Fungsi pilih tanggal
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi ambil semua data dari DB
  Future<void> _loadTransactions() async {
    final data = await DbHelper().getTransactions();
    setState(() {
      _transactions = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F24),
        title: const Text(
          "Tambah Transaksi",
          style: TextStyle(
            fontFamily: "Orbitron",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul transaksi
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Judul Transaksi",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Judul tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nominal
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Jumlah (Rp)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Jumlah tidak boleh kosong";
                      }
                      if (double.tryParse(value) == null) {
                        return "Masukkan angka yang valid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown tipe transaksi
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: "Tipe Transaksi",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "income",
                        child: Text("Pemasukan"),
                      ),
                      DropdownMenuItem(
                        value: "expense",
                        child: Text("Pengeluaran"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Pilih tanggal
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Tanggal: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _pickDate(context),
                        child: const Text("Pilih Tanggal"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tombol simpan
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF142850),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final transaksi = TransactionModel(
                            title: _titleController.text,
                            amount: double.parse(_amountController.text),
                            type: _selectedType,
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(_selectedDate),
                          );

                          await DbHelper().insertTransaction(transaksi);
                          _titleController.clear();
                          _amountController.clear();
                          _selectedType = "income";
                          _selectedDate = DateTime.now();

                          _loadTransactions();
                        }
                      },
                      child: const Text(
                        "Simpan Transaksi",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card hasil input
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final trx = _transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 4,
                  child: ListTile(
                    title: Text(trx.title),
                    subtitle: Text("Tanggal: ${trx.date}"),
                    trailing: Text(
                      (trx.type == "income" ? "+" : "-") +
                          " Rp${trx.amount.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: trx.type == "income" ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
