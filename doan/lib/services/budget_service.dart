import '../models/budget_model.dart';
import 'transaction_service.dart';

class BudgetService {
  static final List<BudgetModel> _budgets = [];

  static List<BudgetModel> get all => List.unmodifiable(_budgets);

  static void add(BudgetModel budget) {
    _budgets.removeWhere((b) => b.group == budget.group);
    _budgets.add(budget);
  }

  static void delete(String id) {
    _budgets.removeWhere((b) => b.id == id);
  }

  static BudgetModel? byGroup(String group) {
    try {
      return _budgets.firstWhere((b) => b.group == group);
    } catch (_) {
      return null;
    }
  }
  static double spent(String group) {
    return TransactionService.totalByGroup(group);
  }

  static double remaining(BudgetModel budget) {
    final used = spent(budget.group);
    return budget.limit - used;
  }

  static bool isOverLimit(BudgetModel budget) {
    return spent(budget.group) > budget.limit;
  }

  static bool isWarning(BudgetModel budget) {
    final used = spent(budget.group);
    return used >= budget.limit * 0.8 && used <= budget.limit;
  }
}
