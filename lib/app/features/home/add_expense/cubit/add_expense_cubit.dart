import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/repositories/expenditure_repository.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit(this._expenditureRepository) : super(AddExpenseState());

  final ExpenditureRepository _expenditureRepository;

  // Dodawanie wydatku --------------------------------add expenditure
  Future<void> addToExpenditureList(
      {required expenseName, required cost}) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    } else {
      try {
        await _expenditureRepository.addToExpenditure(
            cost: cost, expenseName: expenseName);
        emit(AddExpenseState(save: true));
      } catch (error) {
        emit(AddExpenseState(errorMessage: error.toString()));
      }
    }
  }
}
