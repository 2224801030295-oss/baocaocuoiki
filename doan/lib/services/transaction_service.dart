import '../models/transaction_model.dart';

class TransactionService {
  static final List<TransactionModel> _list = [];

  static List<TransactionModel> get all =>
      List.unmodifiable(_list);

  static void add(TransactionModel tx) {
    if (!tx.isIncome) {
      final balance = totalByGroup(tx.group);
      if (balance < tx.amount) {
        throw Exception('Số dư không đủ');
      }
    }

    _list.add(tx);
  }

  static void delete(String id) {
    _list.removeWhere((e) => e.id == id);
  }

  static void update(TransactionModel newTx) {
    final index = _list.indexWhere((e) => e.id == newTx.id);
    if (index == -1) return;
    _list[index] = newTx;
  }

  static List<TransactionModel> byGroup(String group) {
    return _list
        .where((e) => e.group == group)
        .toList();
  }

  static double totalByGroup(String group) {
    double total = 0;

    for (final tx in _list.where((e) => e.group == group)) {
      total += tx.isIncome ? tx.amount : -tx.amount;
    }

    return total;
  }

  static double totalExpense() {
    return _list
        .where((e) => !e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  static double totalIncome() {
    return _list
        .where((e) => e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  static double totalFundIn(String group) {
    return _list
        .where((e) => e.group == group && e.fundIn)
        .fold(0.0, (s, e) => s + e.amount);
  }

  static double totalFundOut(String group) {
    return _list
        .where((e) => e.group == group && e.fundOut)
        .fold(0.0, (s, e) => s + e.amount);
  }

  static double fundBalance(String group) {
    return totalFundIn(group) - totalFundOut(group);
  }
}
