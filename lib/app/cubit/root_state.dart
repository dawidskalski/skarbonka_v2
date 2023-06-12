part of 'root_cubit.dart';

class RootState {
  final User? user;
  final String errorMessage;
  final bool loading;

  RootState({
    this.user,
    this.errorMessage = '',
    this.loading = false,
  });
}
