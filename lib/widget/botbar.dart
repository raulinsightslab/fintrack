import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/views/dashboard.dart';
import 'package:fintrack/views/tambah.dart';
import 'package:fintrack/views/edit.dart';
import 'package:fintrack/views/rekap.dart';
import 'package:flutter/material.dart';

class Botbar extends StatefulWidget {
  const Botbar({super.key});
  static const id = "/botbar";

  @override
  State<Botbar> createState() => _BotbarState();
}

class _BotbarState extends State<Botbar> {
  int selectedindex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const DashboardPage(),
    const TambahPage(),
    const EditPage(),
    const RekapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.surface,
        selectedItemColor: AppColor.button,
        unselectedItemColor: Colors.grey[400],
        currentIndex: selectedindex,
        onTap: (value) {
          setState(() {
            selectedindex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Tambah",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rekap"),
        ],
      ),
    );
  }
}
