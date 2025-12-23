import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final String group;
  final TransactionModel? editTx;

  const AddTransactionScreen({
    super.key,
    required this.group,
    this.editTx,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  bool isIncome = false;
  String category = 'Ăn uống';

  late String selectedGroup;

  final categories = [
    'Ăn uống',
    'Đi lại',
    'Mua sắm',
    'Học tập',
    'Giải trí',
  ];

  final groups = [
    'Cá nhân',
    'Gia đình',
    'Bạn bè',
  ];

  @override
  void initState() {
    super.initState();

    selectedGroup = widget.group; //

    if (widget.editTx != null) {
      titleCtrl.text = widget.editTx!.title;
      amountCtrl.text = widget.editTx!.amount.toString();
      isIncome = widget.editTx!.isIncome;
      category = widget.editTx!.category;
      selectedGroup = widget.editTx!.group;
    }
  }

  void save() {
    if (titleCtrl.text.isEmpty || amountCtrl.text.isEmpty) return;

    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) return;

    TransactionService.add(
      TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleCtrl.text,
        amount: amount,
        date: DateTime.now(),
        isIncome: isIncome,
        category: category,
        group: selectedGroup,
        isTransfer: category == "Chuyển tiền",
      ),
    );


    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editTx == null
            ? "Thêm giao dịch"
            : "Sửa giao dịch"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Ghi chú"),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Số tiền"),
            ),


            DropdownButtonFormField<String>(
              value: selectedGroup,
              items: groups
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (v) => setState(() => selectedGroup = v!),
              decoration: const InputDecoration(labelText: "Quỹ"),
            ),

            DropdownButtonFormField<String>(
              value: category,
              items: categories
                  .map(
                    (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: (v) => setState(() => category = v!),
              decoration: const InputDecoration(labelText: "Danh mục"),
            ),
            SwitchListTile(
              title: const Text("Khoản thu"),
              value: isIncome,
              onChanged: (v) => setState(() => isIncome = v),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: save,
              child: Text(widget.editTx == null ? "Lưu" : "Cập nhật"),
            ),
          ],
        ),
      ),
    );
  }
}
