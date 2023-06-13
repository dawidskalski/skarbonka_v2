part of 'my_account_cubit.dart';

class MyAccountState {
  final List<MyAccountModel>? documents;
  final String errorMessage;
  final bool loading;

  MyAccountState({
    this.documents = const [],
    this.errorMessage = '',
    this.loading = false,
  });
}
