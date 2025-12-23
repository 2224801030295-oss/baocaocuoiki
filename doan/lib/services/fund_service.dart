import '../models/fund_model.dart';
import 'wallet_service.dart';

class FundService {

  static final Map<String, Map<String, FundModel>> _funds = {
    'Cá nhân': {},
    'Gia đình': {},
    'Bạn bè': {},
  };

  static Map<String, Map<String, FundModel>> allFunds() => _funds;

  static Map<String, FundModel> fundsOf(String group) {
    _funds.putIfAbsent(group, () => {});
    return _funds[group]!;
  }

  static bool createFund({
    required String group,
    required String fundName,
    required double amount,
    String? note,
    String? purpose,
  }) {
    if (amount <= 0) return false;
    if (!WalletService.withdraw(amount)) return false;

    final funds = fundsOf(group);

    if (funds.containsKey(fundName)) {
      funds[fundName]!.balance += amount;
    } else {
      funds[fundName] = FundModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: fundName,
        group: group,
        balance: amount,
        note: note,
        purpose: purpose,
      );
    }

    return true;
  }

  static bool useFund({
    required String group,
    required String fundName,
    required double amount,
  }) {
    final fund = _funds[group]?[fundName];
    if (fund == null || fund.balance < amount) return false;

    fund.balance -= amount;
    return true;
  }

  static double totalOfGroup(String group) {
    return fundsOf(group)
        .values
        .fold(0.0, (sum, f) => sum + f.balance);
  }

  static double totalAll() {
    double sum = 0;
    for (final group in _funds.values) {
      for (final fund in group.values) {
        sum += fund.balance;
      }
    }
    return sum;
  }
  static Map<String, double> totalByGroup() {
    final Map<String, double> result = {};

    _funds.forEach((groupName, fundMap) {
      double sum = 0;
      for (final fund in fundMap.values) {
        sum += fund.balance;
      }
      result[groupName] = sum;
    });

    return result;
  }

}
