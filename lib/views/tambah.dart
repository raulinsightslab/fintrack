import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/widget/drawer.dart';
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
    _selectedCategory = _selectedType == 'Pemasukan' ? 'Gaji' : 'Makan';
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.button,
              onPrimary: AppColor.surface,
              onSurface: AppColor.transaksi,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
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
      backgroundColor: AppColor.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.textPrimary),
        backgroundColor: AppColor.background,
        title: Text(
          "Tambah Transaksi",
          style: TextStyle(color: AppColor.textPrimary),
        ),
        centerTitle: true,
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
                initialValue: _selectedType,
                dropdownColor: AppColor.surface,
                decoration: InputDecoration(
                  labelText: 'Jenis Transaksi',
                  labelStyle: TextStyle(color: AppColor.textPrimary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textPrimary),
                  ),
                ),
                style: TextStyle(color: AppColor.textPrimary),
                items: ['Pemasukan', 'Pengeluaran'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: AppColor.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                    _selectedCategory = _selectedType == 'Pemasukan'
                        ? 'Gaji'
                        : 'Makan';
                  });
                },
              ),
              const SizedBox(height: 16),

              // KATEGORI
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                dropdownColor: AppColor.surface,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(color: AppColor.textPrimary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textPrimary),
                  ),
                ),
                style: TextStyle(color: AppColor.textPrimary),
                items:
                    (_selectedType == 'Pemasukan'
                            ? pemasukkanCategories
                            : pengeluaranCategories)
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: AppColor.textPrimary),
                            ),
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
                style: TextStyle(color: AppColor.textPrimary),
                decoration: InputDecoration(
                  labelText: "Jumlah (Rp)",
                  labelStyle: TextStyle(color: AppColor.textPrimary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textPrimary),
                  ),
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
                style: TextStyle(color: AppColor.textPrimary),
                decoration: InputDecoration(
                  labelText: "Catatan",
                  labelStyle: TextStyle(color: AppColor.textPrimary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textPrimary),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // TANGGAL
              Row(
                children: [
                  Text(
                    "Tanggal: ",
                    style: TextStyle(color: AppColor.textPrimary),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(_selectedDate),
                    style: TextStyle(color: AppColor.textPrimary),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.button,
                    ),
                    onPressed: () => _pickDate(context),
                    child: Text(
                      "Pilih Tanggal",
                      style: TextStyle(color: AppColor.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // TOMBOL SIMPAN
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.button,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
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
                          userId: 1,
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

                        _noteController.clear();
                        _amountController.clear();
                        setState(() {
                          _selectedType = 'Pemasukan';
                          _selectedCategory = 'Gaji';
                          _selectedDate = DateTime.now();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    }
                  },
                  child: Text(
                    "Simpan Transaksi",
                    style: TextStyle(color: AppColor.textPrimary),
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
