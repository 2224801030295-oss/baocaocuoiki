class WalletService {
  static double _balance = 0;

  static final Map<String, double> _groupBalance = {
    'Cá nhân': 0,
    'Gia đình': 0,
    'Bạn bè': 0,
  };

  static double get balance => _balance;

  static double balanceByGroup(String group) {
    return _groupBalance[group] ?? 0;
  }

  static void deposit(double amount, {String? group}) {
    _balance += amount;

    if (group != null) {
      _groupBalance[group] = (_groupBalance[group] ?? 0) + amount;
    }
  }

  static bool withdraw(double amount, {String? group}) {
    if (_balance < amount) return false;

    if (group != null && (_groupBalance[group] ?? 0) < amount) {
      return false;
    }

    _balance -= amount;

    if (group != null) {
      _groupBalance[group] = _groupBalance[group]! - amount;
    }

    return true;
  }

  static bool transfer({
    required String fromGroup,
    required String toGroup,
    required double amount,
  }) {
    if (fromGroup == toGroup) return false;
    if ((_groupBalance[fromGroup] ?? 0) < amount) return false;

    _groupBalance[fromGroup] =
        (_groupBalance[fromGroup] ?? 0) - amount;

    _groupBalance[toGroup] =
        (_groupBalance[toGroup] ?? 0) + amount;

    return true;
  }
}
