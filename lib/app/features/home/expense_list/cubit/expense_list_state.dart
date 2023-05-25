part of 'expense_list_cubit.dart';

class ExpenseListState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>?
      expenditureListDocuments;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? wantSpendDocuments;
  final String errorMessage;
  final bool loadingErrorOccured;
  final bool removeErrorOccured;
  final bool addErrorOccured;

  ExpenseListState({
    this.expenditureListDocuments,
    this.wantSpendDocuments,
    this.errorMessage = '',
    this.loadingErrorOccured = false,
    this.removeErrorOccured = false,
    this.addErrorOccured = false,
  });
}
