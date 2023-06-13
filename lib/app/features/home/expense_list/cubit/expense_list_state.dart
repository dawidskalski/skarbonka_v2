part of 'expense_list_cubit.dart';

class ExpenseListState {
  final List<ExpenseModel> expenditureListDocuments;
  final List<ExpenseModel> wantSpendDocuments;
  final String errorMessage;
  final bool loading;

  ExpenseListState({
    this.expenditureListDocuments = const [],
    this.wantSpendDocuments = const [],
    this.errorMessage = '',
    this.loading = false,
  });
}
