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
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColor.button),
            child: Center(
              child: Text(
                "Raul Akbar",
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
