import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class TambahPage extends StatefulWidget {
  static const id = '/add_page';
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategoryId = 'Pemasukan';
  // String selectedJenis = 'Pemasukan';
  DateTime _selectedDate = DateTime.now();

  int? _selectedUserId;
  List<String> pemasukkan = ['Gaji', 'Bonus', 'Investasi'];
  List<String> pengeluaran = ['Makan', 'Transportasi', 'Belanja'];

  // Contoh dummy data user & kategori
  // final List<Map<String, dynamic>> _users = [
  //   // {'id': 1, 'name': 'User 1'},
  //   // {'id': 2, 'name': 'User 2'},
  // ];

  // final List<Map<String, dynamic>> _categories = [
  //   {'id': 1, 'name': 'Pengeluaran'},
  //   {'id': 2, 'name': 'Pemasukkan'},
  // ];

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

  // Future<void> _loadTransactions() async {
  //   final data = await DbHelper.getAllTransaction();
  //   setState(() {
  //     _transactions = data;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadTransactions();
  // }

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
                  Column(
                    children: [Text("Selected User ID : $_selectedUserId")],
                  ), // Pilih kategori
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Jenis Transaksi'),
                    value: _selectedCategoryId,
                    items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategoryId = newValue!;
                        _categoryController.text = '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Note
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: "Catatan",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Catatan kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Jumlah (Rp)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Jumlah kosong";
                      }
                      if (double.tryParse(value) == null) {
                        return "Masukkan angka valid";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _categoryController.text.isEmpty
                        ? null
                        : _categoryController.text,
                    items:
                        (_selectedCategoryId == 'Pemasukan'
                                ? pemasukkan
                                : pengeluaran)
                            .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                    onChanged: (newValue) {
                      _categoryController.text = newValue!;
                    },
                    decoration: InputDecoration(labelText: 'Kategori'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih kategori';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

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
                  Center(
                    // child: ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: const Color(0xFF142850),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 40,
                    //       vertical: 15,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    //   onPressed: () async {
                    //     if (_formKey.currentState!.validate()) {
                    //       double amount = double.parse(_amountController.text);
                    //       if (_selectedCategoryId == 'Pengeluaran') {
                    //         amount = -amount; // jadi minus kalau pengeluaran
                    //       }
                    //       final transaksi = TransactionModel(
                    //         userId: 1,
                    //         categoryId: _selectedCategoryId ?? "",
                    //         amount: amount,
                    //         date: DateFormat(
                    //           'yyyy-MM-dd',
                    //         ).format(_selectedDate),
                    //         note: _noteController.text,
                    //       );
                    //       await DbHelper.addTransaction(transaksi);
                    //       // Reset form
                    //       _noteController.clear();
                    //       _amountController.clear();
                    //       setState(() {
                    //         _selectedCategoryId = null;
                    //         _selectedDate = DateTime.now();
                    //       });

                    //       // _loadTransactions();
                    //     }
                    //   },
                    //   child: const Text(
                    //     "Simpan Transaksi",
                    //     style: TextStyle(color: Colors.white, fontSize: 16),
                    //   ),
                    // ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          double amount = double.parse(_amountController.text);
                          if (_selectedCategoryId == 'Pengeluaran') {
                            amount = -amount;
                          }
                          TransactionModel newTransaksi = TransactionModel(
                            userId: _selectedUserId ?? 1,
                            categoryId: _categoryController.text,
                            amount: amount,
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(_selectedDate),
                            note: _noteController.text,
                            type: _selectedCategoryId!,
                          );
                          await DbHelper.addTransaction(newTransaksi);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Transaksi berhasil disimpan"),
                            ),
                          );
                          _noteController.clear();
                          _amountController.clear();
                          _categoryController.clear();
                          setState(() {
                            _selectedCategoryId = 'Pemasukan';
                            _selectedDate = DateTime.now();
                          });
                        }
                      },
                      child: Text("Simpan Transaksi"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // List transaksi
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: _transactions.length,
            //   itemBuilder: (context, index) {
            //     final trx = _transactions[index];

            //     // cari kategori sesuai id transaksi
            //     // final kategori = _categories.firstWhere(
            //     //   (c) => c['id'] == trx.categoryId,
            //     //   orElse: () => {"name": "Tidak ada kategori"},
            //     // );

            //     // return Card(
            //     //   margin: const EdgeInsets.symmetric(vertical: 6),
            //     //   elevation: 4,
            //     //   child: ListTile(
            //     //     title: Text("${['name']}"),
            //     //     subtitle: Text("Tanggal: ${trx.date}"),
            //     //     trailing: Text(
            //     //       "Rp${trx.amount.toStringAsFixed(0)}",
            //     //       style: const TextStyle(fontWeight: FontWeight.bold),
            //     //     ),
            //     //   ),
            //     // );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
