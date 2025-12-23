import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;


  bool isValidGmail(String email) =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email);

  bool isValidPassword(String password) {
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$&*~%^()\-_+=<>?/]').hasMatch(password);
    return password.length >= 6 && hasUpper && hasSpecial;
  }

  bool isValidPhone(String phone) =>
      RegExp(r'^[0-9]{10}$').hasMatch(phone);


  void register() {
    if (fullCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        userCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        confirmCtrl.text.isEmpty) {
      _toast("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (!isValidGmail(emailCtrl.text)) {
      _toast("Gmail phải đúng dạng @gmail.com");
      return;
    }

    if (!isValidPhone(phoneCtrl.text)) {
      _toast("Số điện thoại phải đúng 10 chữ số");
      return;
    }

    if (!isValidPassword(passCtrl.text)) {
      _toast("Mật khẩu ≥6 ký tự, có chữ HOA và ký tự đặc biệt");
      return;
    }

    if (passCtrl.text != confirmCtrl.text) {
      _toast("Mật khẩu nhập lại không khớp");
      return;
    }

    final ok = AuthService.register(
      fullName: fullCtrl.text,
      email: emailCtrl.text,
      phone: phoneCtrl.text,
      username: userCtrl.text,
      password: passCtrl.text,
    );

    if (ok) {
      _toast("Đăng ký thành công");
      Navigator.pop(context);
    } else {
      _toast("Tên đăng nhập đã tồn tại");
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Đăng ký"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.person_add,
                    size: 60, color: Colors.blue),

                const SizedBox(height: 12),
                const Text(
                  "Tạo tài khoản mới",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                _input(fullCtrl, "Họ và tên", Icons.badge),
                _input(emailCtrl, "Gmail", Icons.email),
                _input(phoneCtrl, "Số điện thoại", Icons.phone,
                    keyboard: TextInputType.phone),
                _input(userCtrl, "Tên đăng nhập", Icons.account_circle),

                _passwordInput(
                  ctrl: passCtrl,
                  label: "Mật khẩu",
                  show: showPassword,
                  toggle: () =>
                      setState(() => showPassword = !showPassword),
                  helper:
                  "≥6 ký tự, 1 chữ hoa & 1 ký tự đặc biệt",
                ),

                _passwordInput(
                  ctrl: confirmCtrl,
                  label: "Nhập lại mật khẩu",
                  show: showConfirmPassword,
                  toggle: () => setState(
                          () => showConfirmPassword = !showConfirmPassword),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: register,
                    child: const Text(
                      "ĐĂNG KÝ",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _input(
      TextEditingController ctrl,
      String label,
      IconData icon, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _passwordInput({
    required TextEditingController ctrl,
    required String label,
    required bool show,
    required VoidCallback toggle,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        obscureText: !show,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon:
            Icon(show ? Icons.visibility : Icons.visibility_off),
            onPressed: toggle,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
