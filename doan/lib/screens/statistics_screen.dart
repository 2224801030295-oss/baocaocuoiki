import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transaction_service.dart';
import '../services/fund_service.dart';
import '../models/transaction_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = TransactionService.all;

    double personalIncome = 0;
    double personalExpense = 0;
    double fundAdded = 0;
    double fundUsed = 0;

    for (final tx in transactions) {
      if (tx.category == "Tạo quỹ") {
        fundAdded += tx.amount;
      } else if (tx.category == "Dùng quỹ") {
        fundUsed += tx.amount;
      } else if (tx.isIncome) {
        personalIncome += tx.amount;
      } else {
        personalExpense += tx.amount;
      }
    }

    final totalFundBalance = FundService.totalAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thống kê"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card("Thu cá nhân", personalIncome, Colors.green, Icons.add),
          _card("Chi cá nhân", personalExpense, Colors.red, Icons.remove),
          _card("Nạp vào quỹ", fundAdded, Colors.blue, Icons.account_balance),
          _card("Dùng từ quỹ", fundUsed, Colors.orange, Icons.payments),
          _card("Số dư tất cả quỹ", totalFundBalance, Colors.teal, Icons.savings),
          const SizedBox(height: 30),
          SizedBox(
            height: 280,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  if (personalIncome > 0)
                    _section(
                      value: personalIncome,
                      color: Colors.green,
                      title: "Thu\n${personalIncome.toInt()}",
                    ),
                  if (personalExpense > 0)
                    _section(
                      value: personalExpense,
                      color: Colors.red,
                      title: "Chi\n${personalExpense.toInt()}",
                    ),
                  if (fundAdded > 0)
                    _section(
                      value: fundAdded,
                      color: Colors.blue,
                      title: "Nạp quỹ\n${fundAdded.toInt()}",
                    ),
                  if (fundUsed > 0)
                    _section(
                      value: fundUsed,
                      color: Colors.orange,
                      title: "Dùng quỹ\n${fundUsed.toInt()}",
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section({
    required double value,
    required Color color,
    required String title,
  }) {
    return PieChartSectionData(
      value: value,
      title: title,
      color: color,
      radius: 80,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _card(
      String title,
      double value,
      Color color,
      IconData icon,
      ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          "${value.toInt()} đ",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
