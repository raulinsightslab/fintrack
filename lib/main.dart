import 'package:fintrack/splash_screen/splash.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/views/dashboard.dart';
import 'package:fintrack/views/edit.dart';
import 'package:fintrack/views/login.dart';
import 'package:fintrack/views/register.dart';
import 'package:fintrack/views/rekap.dart';
import 'package:fintrack/views/tambah.dart';
import 'package:fintrack/widget/botbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return format.format(amount);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack - Pencatatan Keuangan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.textPrimary),
      ),
      //
      home: Day16SplashScreen(),
      routes: {
        "/login": (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        DashboardPage.id: (context) => const DashboardPage(),
        Botbar.id: (context) => const Botbar(),
        TambahPage.id: (context) => const TambahPage(),
        EditPage.id: (context) => const EditPage(),
        RekapPage.id: (context) => const RekapPage(),
      },
    );
  }
}
