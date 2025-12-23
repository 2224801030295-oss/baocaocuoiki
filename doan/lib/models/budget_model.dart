class BudgetModel {
  final String id;
  final String group;
  final double limit;
  final DateTime startDate;
  final DateTime endDate;

  BudgetModel({
    required this.id,
    required this.group,
    required this.limit,
    required this.startDate,
    required this.endDate,
  });
}
