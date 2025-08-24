import 'package:fintrack/model/transaksi.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  static const id = '/edit_page';
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<TransactionModel> transactions = [];
  int currentUserId = 1; // Ganti dengan ID user yang login

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transaksi = await DbHelper.getTransactionsByUserId(currentUserId);
    setState(() {
      transactions = transaksi;
    });
  }

  Future<void> _deleteTransaction(int id) async {
    await DbHelper.deleteTransaction(id);
    _loadTransactions();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Transaksi dihapus")));
  }

  void _showDeleteConfirmationDialog(TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.surface,
          title: Text(
            "Konfirmasi Hapus",
            style: TextStyle(color: AppColor.textPrimary),
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus transaksi '${transaction.note}'?",
            style: TextStyle(color: AppColor.textPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Batal",
                style: TextStyle(color: AppColor.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTransaction(transaction.id!);
              },
              child: Text("Hapus", style: TextStyle(color: AppColor.expense)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: AppColor.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.textPrimary),
        backgroundColor: AppColor.surface,
        title: Text(
          "Edit Transaksi",
          style: TextStyle(color: AppColor.textPrimary),
        ),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                "Belum ada transaksi",
                style: TextStyle(color: AppColor.textPrimary),
              ),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Dismissible(
                  key: Key(transaction.id.toString()),
                  background: Container(
                    color: AppColor.expense,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: AppColor.expense,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: AppColor.surface,
                          title: Text(
                            "Konfirmasi Hapus",
                            style: TextStyle(color: AppColor.textPrimary),
                          ),
                          content: Text(
                            "Apakah Anda yakin ingin menghapus transaksi '${transaction.note}'?",
                            style: TextStyle(color: AppColor.textPrimary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                "Batal",
                                style: TextStyle(color: AppColor.textPrimary),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                "Hapus",
                                style: TextStyle(color: AppColor.expense),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart ||
                        direction == DismissDirection.startToEnd) {
                      _deleteTransaction(transaction.id!);
                    }
                  },
                  child: Card(
                    color: AppColor.surface,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        transaction.type == "Pemasukan"
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction.type == "Pemasukan"
                            ? AppColor.income
                            : AppColor.expense,
                      ),
                      title: Text(
                        transaction.note,
                        style: TextStyle(color: AppColor.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.categoryId,
                            style: TextStyle(color: AppColor.textSecondary),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(transaction.date),
                            style: TextStyle(color: AppColor.textSecondary),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 0,
                            ).format(transaction.amount),
                            style: TextStyle(
                              color: transaction.type == "Pemasukan"
                                  ? AppColor.income
                                  : AppColor.expense,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: AppColor.expense),
                            onPressed: () {
                              _showDeleteConfirmationDialog(transaction);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _showEditDialog(transaction);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showEditDialog(TransactionModel transaction) {
    final TextEditingController amountController = TextEditingController(
      text: transaction.amount.toString(),
    );
    final TextEditingController noteController = TextEditingController(
      text: transaction.note,
    );

    String selectedType = transaction.type;
    String selectedCategory = transaction.categoryId;
    DateTime selectedDate = transaction.date;

    List<String> pemasukkanCategories = [
      'Gaji',
      'Bonus',
      'Investasi',
      'Lainnya',
    ];
    List<String> pengeluaranCategories = [
      'Makan',
      'Transportasi',
      'Belanja',
      'Hiburan',
      'Lainnya',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColor.surface,
              title: Text(
                "Edit Transaksi",
                style: TextStyle(color: AppColor.textPrimary),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Jenis Transaksi',
                        labelStyle: TextStyle(color: AppColor.textPrimary),
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: AppColor.surface,
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
                          selectedType = newValue!;
                          selectedCategory = selectedType == 'Pemasukan'
                              ? 'Gaji'
                              : 'Makan';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        labelStyle: TextStyle(color: AppColor.textPrimary),
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: AppColor.surface,
                      items:
                          (selectedType == 'Pemasukan'
                                  ? pemasukkanCategories
                                  : pengeluaranCategories)
                              .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColor.textPrimary),
                      decoration: InputDecoration(
                        labelText: "Jumlah (Rp)",
                        labelStyle: TextStyle(color: AppColor.textPrimary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: noteController,
                      style: TextStyle(color: AppColor.textPrimary),
                      decoration: InputDecoration(
                        labelText: "Catatan",
                        labelStyle: TextStyle(color: AppColor.textPrimary),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Tanggal: ",
                          style: TextStyle(color: AppColor.textPrimary),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(selectedDate),
                          style: TextStyle(color: AppColor.textSecondary),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.button,
                          ),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppColor.button,
                                      onPrimary: AppColor.textPrimary,
                                      onSurface: AppColor.textPrimary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Text(
                            "Pilih Tanggal",
                            style: TextStyle(color: AppColor.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: TextStyle(color: AppColor.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteConfirmationDialog(transaction);
                  },
                  child: Text(
                    "Hapus",
                    style: TextStyle(color: AppColor.expense),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Jumlah harus diisi")),
                      );
                      return;
                    }
                    try {
                      final updatedTransaction = TransactionModel(
                        id: transaction.id,
                        userId: transaction.userId,
                        categoryId: selectedCategory,
                        amount: double.parse(amountController.text),
                        date: selectedDate,
                        note: noteController.text,
                        type: selectedType,
                      );
                      await DbHelper.updateTransaction(updatedTransaction);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Transaksi berhasil diupdate")),
                      );
                      _loadTransactions();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: Text(
                    "Simpan",
                    style: TextStyle(color: AppColor.textPrimary),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
