import 'package:fintrack/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const id = "/drawer";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColor.button),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColor.surface,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Raul Akbar",
                    style: TextStyle(
                      color: AppColor.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColor.textPrimary),
            title: Text(
              "Logout",
              style: TextStyle(color: AppColor.textPrimary),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColor.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    "Konfirmasi",
                    style: TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "Apakah Anda yakin ingin keluar?",
                    style: TextStyle(color: AppColor.textPrimary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // tutup dialog
                      child: Text(
                        "Batal",
                        style: TextStyle(color: AppColor.textPrimary),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.button,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Keluar",
                        style: TextStyle(color: AppColor.textPrimary),
                      ),
                    ),
                  ],
                ),
              );
              // Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
