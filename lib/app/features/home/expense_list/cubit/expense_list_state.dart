part of 'expense_list_cubit.dart';

class ExpenseListState {
  final List<ExpenditureModel> expenditureListDocuments;
  final List<WantspendModel> wantSpendDocuments;
  final String errorMessage;
  final bool loading;

  ExpenseListState({
    this.expenditureListDocuments = const [],
    this.wantSpendDocuments = const [],
    this.errorMessage = '',
    this.loading = false,
  });
}
