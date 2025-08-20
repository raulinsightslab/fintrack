import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F24),
        title: const Text(
          "About Us",
          style: TextStyle(
            fontFamily: "Orbitron",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      // drawer: CustomDrawer(),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF142850),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                """SharkNet adalah platform pintar yang membantu Anda mengelola informasi, memilih produk, dan mengatur pengingat dengan cepat serta mudah.
Didesain dengan antarmuka sederhana dan fitur yang efisien, SharkNet hadir untuk mempermudah aktivitas sehari-hari Anda.

Dibuat oleh: Raul Akbarullah
Versi: 1.0.0""",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Arimo",
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
