part of 'expense_list_cubit.dart';

class ExpenseListState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents;
  final String errorMessage;
  final bool loading;

  ExpenseListState({
    required this.documents,
    required this.errorMessage,
    required this.loading,
  });
}
