part of 'my_account_cubit.dart';

class MyAccountState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents;
  final String errorMessage;
  final bool loading;

  MyAccountState({
    required this.documents,
    required this.errorMessage,
    required this.loading,
  });
}
