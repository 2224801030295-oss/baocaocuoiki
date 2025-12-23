import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../services/transaction_service.dart';
import '../models/transaction_model.dart';
import 'group_detail_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'withdraw_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final groups = ['Cá nhân', 'Gia đình', 'Bạn bè'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          _homePage(),
          StatisticsScreen(), // ✅ BỎ const → THỐNG KÊ CẬP NHẬT
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Chi tiêu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Thống kê",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Cài đặt",
          ),
        ],
      ),
    );
  }


  Widget _homePage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý chi tiêu"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _walletCard(),
          const SizedBox(height: 20),
          _walletActions(),
          const SizedBox(height: 30),
          const Text(
            "Nhóm chi tiêu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...groups.map(_groupItem),
        ],
      ),
    );
  }

  Widget _walletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xff4f46e5), Color(0xff6366f1)],
        ),
      ),
      child: Column(
        children: [
          const Text("Số dư hiện tại", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            "${WalletService.balance.toInt()} đ",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(
          icon: Icons.add,
          label: "Nạp",
          color: Colors.green,
          onTap: _deposit,
        ),
        _actionButton(
          icon: Icons.remove,
          label: "Chi",
          color: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WithdrawScreen(group: 'Cá nhân'),
              ),
            ).then((_) => setState(() {}));
          },
        ),
        _actionButton(
          icon: Icons.compare_arrows,
          label: "Chuyển",
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WithdrawScreen(
                  group: 'Cá nhân',
                  isTransfer: true,
                ),
              ),
            ).then((_) => setState(() {}));
          },
        ),
      ],
    );
  }

  void _deposit() {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nạp tiền"),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Số tiền"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(ctrl.text);
              if (amount == null || amount <= 0) return;

              WalletService.deposit(amount);

              TransactionService.add(
                TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: "Nạp tiền",
                  amount: amount,
                  date: DateTime.now(),
                  isIncome: true,
                  category: "Nạp ví",
                  group: "Cá nhân",
                ),
              );

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  Widget _groupItem(String group) {
    final total = TransactionService.totalByGroup(group);

    return Card(
      child: ListTile(
        title: Text(group),
        trailing: Text(
          "-${total.toInt()} đ",
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GroupDetailScreen(group: group),
            ),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
