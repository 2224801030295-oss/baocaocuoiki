import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../admin/screens/manage_users_screen.dart';
import '../admin/screens/manage_transactions_screen.dart';
import '../screens/login_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị hệ thống'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _adminCard(
              icon: Icons.people,
              title: 'Quản lý người dùng',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageUsersScreen(),
                  ),
                );
              },
            ),
            _adminCard(
              icon: Icons.monetization_on,
              title: 'Quản lý giao dịch',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageTransactionsScreen(),
                  ),
                );
              },
            ),
            _adminCard(
              icon: Icons.bar_chart,
              title: 'Thống kê toàn hệ thống',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng thống kê sẽ làm sau'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
