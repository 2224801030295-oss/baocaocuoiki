class FundModel {
  final String id;
  final String name;
  final String group;
  double balance;
  final String? note;
  final String? purpose;

  FundModel({
    required this.id,
    required this.name,
    required this.group,
    required this.balance,
    this.note,
    this.purpose,
  });
}
