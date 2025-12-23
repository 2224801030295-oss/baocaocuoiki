import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../services/wallet_service.dart';
import '../services/fund_service.dart';

class WithdrawScreen extends StatefulWidget {
  final String group;
  final bool isTransfer;

  const WithdrawScreen({
    super.key,
    required this.group,
    this.isTransfer = false,
  });

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController amountCtrl = TextEditingController();
  String? selectedFund;

  void submit() {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) return;

    if (!widget.isTransfer) {
      final ok = WalletService.withdraw(amount);
      if (!ok) return;

      Navigator.pop(context);
      return;
    }

    if (selectedFund == null) return;

    final ok = FundService.useFund(
      group: widget.group,
      fundName: selectedFund!,
      amount: amount,
    );

    if (!ok) return;

    TransactionService.add(
      TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: "Chi từ quỹ $selectedFund",
        amount: amount,
        date: DateTime.now(),
        isIncome: false,
        category: "Chi quỹ",
        group: widget.group,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final funds = FundService.fundsOf(widget.group);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTransfer ? "Chuyển tiền" : "Rút tiền"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số tiền",
              ),
            ),

            if (widget.isTransfer) ...[
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedFund,
                decoration:
                const InputDecoration(labelText: "Chọn quỹ"),
                items: funds.entries.map((entry) {
                  final fund = entry.value;
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(
                      "${fund.name} (${fund.balance.toInt()} đ)",
                    ),
                  );
                }).toList(),
                onChanged: (v) =>
                    setState(() => selectedFund = v),
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text("Xác nhận"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
