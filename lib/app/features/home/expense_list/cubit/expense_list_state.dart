part of 'expense_list_cubit.dart';

class ExpenseListState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>?
      expenditureListDocuments;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? wantSpendDocuments;
  final String errorMessage;
  final bool loading;

  ExpenseListState({
    this.expenditureListDocuments,
    this.wantSpendDocuments,
    this.errorMessage = '',
    this.loading = false,
  });
}
