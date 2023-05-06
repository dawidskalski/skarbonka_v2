part of 'root_cubit.dart';

class RootState {
  final User? user;
  final String errorMessage;
  final bool loading;

  RootState({
    required this.user,
    required this.errorMessage,
    required this.loading,
  });
}
