import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'login_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Tài khoản"),
            subtitle: Text(
              AuthService.currentUser ?? "Chưa đăng nhập",
            ),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Đổi mật khẩu"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Hỗ trợ khách hàng",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Liên hệ CSKH"),
            subtitle: const Text("Hotline: 1900 9999"),
            onTap: () {
              _showInfoDialog(
                context,
                "Liên hệ CSKH",
                "Hotline: 1900 9999\nEmail: support@app.com",
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text("Gửi phản hồi"),
            onTap: () {
              _showInfoDialog(
                context,
                "Phản hồi",
                "Cảm ơn bạn đã góp ý để ứng dụng tốt hơn ❤️",
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Câu hỏi thường gặp"),
            onTap: () {
              _showInfoDialog(
                context,
                "FAQ",
                "• Làm sao tạo quỹ?\n• Làm sao rút tiền?\n• Quỹ có giới hạn không?",
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Giới thiệu ứng dụng"),
            onTap: () {
              _showInfoDialog(
                context,
                "Giới thiệu",
                "Ứng dụng quản lý chi tiêu & quỹ cá nhân.\nPhiên bản 1.0.0",
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Điều khoản & Chính sách"),
            onTap: () {
              _showInfoDialog(
                context,
                "Điều khoản",
                "Dữ liệu được lưu cục bộ.\nKhông chia sẻ cho bên thứ ba.",
              );
            },
          ),

          const Divider(),


          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                    (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  static void _showInfoDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          )
        ],
      ),
    );
  }
}
