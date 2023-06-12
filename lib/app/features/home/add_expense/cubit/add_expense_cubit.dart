import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit() : super(AddExpenseState());

  // Dodawanie wydatku --------------------------------add expenditure
  Future<void> addToExpenditureList(expenseName) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userdID)
          .collection('expenditure')
          .add({
        'name': expenseName,
      });
      emit(AddExpenseState(save: true));
    } catch (error) {
      emit(AddExpenseState(errorMessage: error.toString()));
    }
  }
}
