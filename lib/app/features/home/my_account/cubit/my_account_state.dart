part of 'my_account_cubit.dart';

class MyAccountState {
  final List<WantspendModel> wantSpendDocuments;
  final String errorMessage;
  final bool loading;

  MyAccountState({
    this.wantSpendDocuments = const [],
    this.errorMessage = '',
    this.loading = false,
  });
}
