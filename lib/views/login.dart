import 'package:fintrack/extension/navigation.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/views/register.dart';
import 'package:fintrack/widget/botbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const id = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // // Logo
              // Image.asset("assets/image/logo_faztrack.png", height: 120),
              Lottie.asset("assets/lottie/Piggy_Bank.json", height: 200),
              SizedBox(height: 20),
              // Title
              Text(
                "FinTrack",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColor.expense,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                "Track Money\nShape Your Future",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColor.textPrimary),
              ),
              const SizedBox(height: 40),

              // Email field
              TextFormField(
                style: TextStyle(color: AppColor.textPrimary),
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: AppColor.textPrimary),
                  hintText: "Enter Your Email",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.textPrimary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              TextFormField(
                style: TextStyle(color: AppColor.textPrimary),
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: AppColor.textPrimary),
                  hintText: "Enter Your Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Email dan Password harus diisi"),
                        ),
                      );
                      return;
                    }

                    // final dbHelper = DbHelper();
                    final user = await DbHelper.loginUser(email, password);

                    if (user != null) {
                      // Login berhasil
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Login berhasil, selamat datang ${user.nama}!",
                          ),
                        ),
                      );
                      context.pushNamed(Botbar.id);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email atau Password salah")),
                      );
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: AppColor.textPrimary),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Or continue with
              Text(
                "Or continue with",
                style: TextStyle(color: AppColor.textPrimary),
              ),
              SizedBox(height: 15),

              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton("assets/image/icon_google.png"),
                  SizedBox(width: 15),
                  _socialButton("assets/image/icon_apple.png"),
                  SizedBox(width: 15),
                  _socialButton("assets/image/icon_twitter.png"),
                ],
              ),
              SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(RegisterPage.id);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: AppColor.textPrimary),
                        ),
                        TextSpan(
                          text: "Register here",
                          style: TextStyle(
                            color: AppColor.expense,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk social login button
  Widget _socialButton(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(assetPath, height: 28, width: 28),
    );
  }
}
