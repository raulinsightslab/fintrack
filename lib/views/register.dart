import 'package:fintrack/extension/navigation.dart';
import 'package:fintrack/model/user_register.dart';
import 'package:fintrack/sqflite/db_helper.dart';
import 'package:fintrack/utils/app_color.dart';
import 'package:fintrack/views/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const id = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Lottie.asset("assets/lottie/Piggy_Bank.json", height: 200),
                // Image.asset("assets/image/logo_faztrack.png", height: 120),
                SizedBox(height: 15),

                // Title
                Text(
                  "Register Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.expense,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  "Buat akun baru untuk mulai mencatat keuanganmu",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColor.textPrimary),
                ),
                const SizedBox(height: 40),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    labelStyle: TextStyle(color: AppColor.textPrimary),
                    hintText: "Enter your full name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Name required" : null,
                ),
                const SizedBox(height: 20),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: AppColor.textPrimary),
                    hintText: "Enter your email",
                    border:
                        // AppColor.textPrimary
                        OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.textPrimary),
                          borderRadius: BorderRadius.circular(10),
                          // borderSide: AppColor.textPrimary,
                        ),
                  ),
                  validator: (value) => value == null || !value.contains("@")
                      ? "Enter a valid email"
                      : null,
                ),
                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
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
                  validator: (value) => value == null || value.length < 6
                      ? "Password must be at least 6 characters"
                      : null,
                ),
                const SizedBox(height: 25),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final nama = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;

                      if (email.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Invalid Email"),
                              content: Text("Please enter a valid email."),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else if (password.length != 6) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Password Invalid"),
                              content: Text(
                                "Password harus mengandung 6 karakter.",
                              ),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // final dbHelper = DbHelper();
                        final user = Userregist(
                          nama: nama,
                          email: email,
                          password: password,
                        );
                        await DbHelper.registerUser(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Register Successful')),
                        );
                        context.pushNamed(LoginPage.id);
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Sudah punya akun? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login di sini",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
