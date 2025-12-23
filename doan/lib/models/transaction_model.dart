class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  final bool isIncome;

  final String category;

  final String group;

  final String? fundName;

  final String? note;

  final bool isTransfer;
  final String? toGroup;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
    required this.group,

    this.fundName,
    this.note,

    this.isTransfer = false,
    this.toGroup,
  });

  bool get isExpense => !isIncome && !isTransfer;

  bool get isDeposit => isIncome && !isTransfer;

  bool get isFundExpense =>
      isExpense && fundName != null;

  bool get isFundCreate =>
      isIncome && category == "Tạo quỹ";

  bool get isGroupTransfer => isTransfer;
  bool get fundIn =>
      isIncome && !isTransfer && fundName != null;

  bool get fundOut =>
      !isIncome && !isTransfer && fundName != null;

}
