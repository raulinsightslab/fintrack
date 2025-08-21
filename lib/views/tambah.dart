import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahPage extends StatefulWidget {
  static const id = '/add_page';
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedType = 'Pemasukan';
  String _selectedCategory = 'Gaji'; // Default value untuk kategori
  DateTime _selectedDate = DateTime.now();

  List<String> pemasukkanCategories = ['Gaji', 'Bonus', 'Investasi', 'Lainnya'];
  List<String> pengeluaranCategories = [
    'Makan',
    'Transportasi',
    'Belanja',
    'Hiburan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    // Set kategori default berdasarkan jenis transaksi
    _selectedCategory = _selectedType == 'Pemasukan' ? 'Gaji' : 'Makan';
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F24),
        title: const Text("Tambah Transaksi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JENIS TRANSAKSI
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Jenis Transaksi',
                  border: OutlineInputBorder(),
                ),
                items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                    // Set kategori default berdasarkan jenis transaksi
                    _selectedCategory = _selectedType == 'Pemasukan'
                        ? 'Gaji'
                        : 'Makan';
                  });
                },
              ),
              const SizedBox(height: 16),

              // KATEGORI
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items:
                    (_selectedType == 'Pemasukan'
                            ? pemasukkanCategories
                            : pengeluaranCategories)
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih kategori';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // JUMLAH
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah (Rp)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan jumlah";
                  }
                  if (double.tryParse(value) == null) {
                    return "Masukkan angka yang valid";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // CATATAN
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: "Catatan",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // TANGGAL
              Row(
                children: [
                  const Text("Tanggal: "),
                  Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _pickDate(context),
                    child: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // TOMBOL SIMPAN
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0F24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Pastikan kategori terpilih
                      if (_selectedCategory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Pilih kategori terlebih dahulu"),
                          ),
                        );
                        return;
                      }

                      try {
                        final transaction = TransactionModel(
                          userId: 1, // Ganti dengan ID user yang login
                          categoryId: _selectedCategory,
                          amount: double.parse(_amountController.text),
                          date: _selectedDate,
                          note: _noteController.text,
                          type: _selectedType,
                        );

                        await DbHelper.addTransaction(transaction);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Transaksi berhasil disimpan"),
                          ),
                        );

                        // Reset form
                        _noteController.clear();
                        _amountController.clear();
                        setState(() {
                          _selectedType = 'Pemasukan';
                          _selectedCategory = 'Gaji'; // Reset ke nilai default
                          _selectedDate = DateTime.now();
                        });

                        // Navigator.push();
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    }
                  },
                  child: const Text(
                    "Simpan Transaksi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
