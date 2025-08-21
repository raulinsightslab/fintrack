import 'package:fintrack/extension/navigation.dart';
import 'package:fintrack/sharepreferenced/preferences.dart';
import 'package:fintrack/views/dashboard.dart';
import 'package:fintrack/views/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Day16SplashScreen extends StatefulWidget {
  const Day16SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<Day16SplashScreen> createState() => _Day16SplashScreenState();
}

class _Day16SplashScreenState extends State<Day16SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        context.pushReplacementNamed(DashboardPage.id);
      } else {
        context.push(LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset("assets/image/logo_faztrack.png"),
              Lottie.asset("assets/lottie/Piggy_Bank.json", height: 250),
              SizedBox(height: 20),
              Text("Fintrack"),
            ],
          ),
        ),
      ),
    );
  }
}
