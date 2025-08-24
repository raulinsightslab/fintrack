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

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text(
            "Apakah Anda yakin ingin menghapus transaksi '${transaction.note}'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteTransaction(transaction.id!); // Hapus transaksi
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.textPrimary),
        backgroundColor: AppColor.background,
        title: Text(
          "Edit Transaksi",
          style: TextStyle(color: AppColor.textPrimary),
        ),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? Center(child: Text("Belum ada transaksi"))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Dismissible(
                  key: Key(transaction.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Tampilkan dialog konfirmasi sebelum menghapus
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi Hapus"),
                          content: Text(
                            "Apakah Anda yakin ingin menghapus transaksi '${transaction.note}'?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
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
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction.categoryId),
                          Text(
                            DateFormat('dd MMM yyyy').format(transaction.date),
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
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(transaction);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigasi ke halaman edit detail
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
    // Controller untuk form edit
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
              title: const Text("Edit Transaksi"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // JENIS TRANSAKSI
                    DropdownButtonFormField<String>(
                      value: selectedType,
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
                          selectedType = newValue!;
                          // Reset kategori sesuai jenis transaksi
                          selectedCategory = selectedType == 'Pemasukan'
                              ? 'Gaji'
                              : 'Makan';
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // KATEGORI
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          (selectedType == 'Pemasukan'
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
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // JUMLAH
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Jumlah (Rp)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CATATAN
                    TextFormField(
                      controller: noteController,
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
                        Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: const Text("Pilih Tanggal"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                // Tombol Hapus di dialog edit
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog edit
                    _showDeleteConfirmationDialog(
                      transaction,
                    ); // Tampilkan dialog hapus
                  },
                  child: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Jumlah harus diisi")),
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
                        const SnackBar(
                          content: Text("Transaksi berhasil diupdate"),
                        ),
                      );

                      // Reload data
                      _loadTransactions();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
