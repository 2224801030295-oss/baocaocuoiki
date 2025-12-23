import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';
import '../../screens/login_screen.dart';
import 'manage_users_screen.dart';
import 'manage_transactions_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _logout(BuildContext context) {
    AuthService.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Quản lý người dùng'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageUsersScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Quản lý giao dịch'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ManageTransactionsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
