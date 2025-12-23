class WalletService {
  static double _balance = 0;

  static double get balance => _balance;
  static void deposit(double amount) {
    if (amount <= 0) return;
    _balance += amount;
  }
  static bool withdraw(double amount) {
    if (amount <= 0) return false;
    if (amount > _balance) return false;

    _balance -= amount;
    return true;
  }

  static void reset() {
    _balance = 0;
  }
}
