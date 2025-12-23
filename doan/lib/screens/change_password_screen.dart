import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool hideOld = true;
  bool hideNew = true;
  bool hideConfirm = true;

  void submit() {
    if (newCtrl.text != confirmCtrl.text) {
      _msg("Mật khẩu mới không khớp");
      return;
    }

    final ok = AuthService.changePassword(
      oldCtrl.text,
      newCtrl.text,
    );

    if (ok) {
      _msg("Đổi mật khẩu thành công");
      Navigator.pop(context);
    } else {
      _msg("Mật khẩu cũ không đúng");
    }
  }

  void _msg(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đổi mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field(oldCtrl, "Mật khẩu cũ", hideOld, () {
              setState(() => hideOld = !hideOld);
            }),
            _field(newCtrl, "Mật khẩu mới", hideNew, () {
              setState(() => hideNew = !hideNew);
            }),
            _field(confirmCtrl, "Nhập lại mật khẩu", hideConfirm, () {
              setState(() => hideConfirm = !hideConfirm);
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: const Text("Xác nhận"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController ctrl,
      String label,
      bool hide,
      VoidCallback toggle,
      ) {
    return TextField(
      controller: ctrl,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
    );
  }
}
