import 'package:flutter/material.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction_model.dart';

class ManageTransactionsScreen extends StatefulWidget {
  const ManageTransactionsScreen({super.key});

  @override
  State<ManageTransactionsScreen> createState() =>
      _ManageTransactionsScreenState();
}

class _ManageTransactionsScreenState
    extends State<ManageTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = TransactionService.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý giao dịch')),
      body: transactions.isEmpty
          ? const Center(child: Text('Chưa có giao dịch'))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(tx.title),
              subtitle: Text(
                '${tx.group} | ${tx.isIncome ? "Thu" : "Chi"}',
              ),
              trailing: Text(
                tx.amount.toString(),
                style: TextStyle(
                  color: tx.isIncome
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
