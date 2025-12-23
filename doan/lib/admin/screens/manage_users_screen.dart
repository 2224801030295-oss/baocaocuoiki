import 'package:flutter/material.dart';
import '../../auth/auth_service.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = AuthService.allUsers;

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: users.isEmpty
          ? const Center(child: Text('Chưa có người dùng'))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final u = users[index];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(u['username'] ?? ''),
            subtitle: Text(
                '${u['email']} | Role: ${u['role']}'),
          );
        },
      ),
    );
  }
}
