import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../services/fund_service.dart';

class GroupDetailScreen extends StatefulWidget {
  final String group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions =
    TransactionService.byGroup(widget.group);
    final funds =
    FundService.fundsOf(widget.group);
    final totalFund =
    FundService.totalOfGroup(widget.group);

    return Scaffold(
      appBar: AppBar(
        title: Text("Nhóm: ${widget.group}"),
      ),

      /// ➕ / ➖ QUỸ
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "createFund",
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
            onPressed: _createFund,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "useFund",
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
            onPressed: _useFund,
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 💰 TỔNG QUỸ
          Card(
            child: ListTile(
              title: const Text("Tổng số dư quỹ"),
              trailing: Text(
                "${totalFund.toInt()} đ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🏦 DANH SÁCH QUỸ
          const Text(
            "Danh sách quỹ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          if (funds.isEmpty)
            const Text("Chưa có quỹ nào")
          else
            ...funds.values.map(
                  (fund) => Card(
                child: ListTile(
                  title: Text(fund.name),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      if (fund.purpose != null &&
                          fund.purpose!.isNotEmpty)
                        Text("🎯 ${fund.purpose}"),
                      if (fund.note != null &&
                          fund.note!.isNotEmpty)
                        Text("📝 ${fund.note}"),
                    ],
                  ),
                  trailing: Text(
                    "${fund.balance.toInt()} đ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),

          /// 📄 LỊCH SỬ
          const Text(
            "Lịch sử giao dịch",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          if (transactions.isEmpty)
            const Text("Chưa có giao dịch")
          else
            ...transactions.map(
                  (tx) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    tx.isIncome
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      tx.isIncome
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(tx.title),
                  subtitle: Text(tx.category),
                  trailing: Text(
                    "${tx.isIncome ? "+" : "-"}${tx.amount.toInt()} đ",
                    style: TextStyle(
                      color: tx.isIncome
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onLongPress: () {
                    TransactionService.delete(tx.id);
                    setState(() {});
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// =========================
  /// ➕ TẠO QUỸ
  /// =========================
  void _createFund() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tạo quỹ mới"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration:
                const InputDecoration(labelText: "Tên quỹ"),
              ),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: "Số tiền"),
              ),
              TextField(
                controller: purposeCtrl,
                decoration:
                const InputDecoration(labelText: "Mục đích"),
              ),
              TextField(
                controller: noteCtrl,
                decoration:
                const InputDecoration(labelText: "Ghi chú"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Huỷ"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Tạo"),
            onPressed: () {
              final amount =
              double.tryParse(amountCtrl.text);
              if (amount == null ||
                  amount <= 0 ||
                  nameCtrl.text.isEmpty) return;

              final ok = FundService.createFund(
                group: widget.group,
                fundName: nameCtrl.text,
                amount: amount,
                purpose: purposeCtrl.text,
                note: noteCtrl.text,
              );

              if (!ok) return;

              TransactionService.add(
                TransactionModel(
                  id: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(),
                  title: "Tạo quỹ ${nameCtrl.text}",
                  amount: amount,
                  date: DateTime.now(),
                  isIncome: true,
                  category: "Tạo quỹ",
                  group: widget.group,
                ),
              );

              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  /// =========================
  /// ➖ DÙNG QUỸ
  /// =========================
  void _useFund() {
    final amountCtrl = TextEditingController();
    final funds =
    FundService.fundsOf(widget.group);
    String? selectedFund;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Dùng quỹ"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              items: funds.keys
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: (v) => selectedFund = v,
              decoration:
              const InputDecoration(labelText: "Chọn quỹ"),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: "Số tiền"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Huỷ"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Xác nhận"),
            onPressed: () {
              final amount =
              double.tryParse(amountCtrl.text);
              if (amount == null ||
                  amount <= 0 ||
                  selectedFund == null) return;

              final ok = FundService.useFund(
                group: widget.group,
                fundName: selectedFund!,
                amount: amount,
              );

              if (!ok) return;

              TransactionService.add(
                TransactionModel(
                  id: DateTime.now()
                      .millisecondsSinceEpoch
                      .toString(),
                  title: "Dùng quỹ $selectedFund",
                  amount: amount,
                  date: DateTime.now(),
                  isIncome: false,
                  category: "Dùng quỹ",
                  group: widget.group,
                ),
              );

              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
