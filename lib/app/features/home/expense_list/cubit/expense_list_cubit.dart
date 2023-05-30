import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit()
      : super(ExpenseListState(
          expenditureListDocuments: [],
          wantSpendDocuments: [],
          errorMessage: '',
          loadingErrorOccured: false,
        ));
  StreamSubscription? _wannaspendSubscription;
  StreamSubscription? _expenditureSubscription;

  Future<void> start() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      ExpenseListState(
        wantSpendDocuments: [],
        expenditureListDocuments: [],
        errorMessage: '',
        loadingErrorOccured: true,
      ),
    );

    _wannaspendSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('wantspend')
        .snapshots()
        .listen(
      (data) {
        emit(ExpenseListState(
          wantSpendDocuments: data.docs,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            wantSpendDocuments: [],
            errorMessage: error.toString(),
            loadingErrorOccured: true,
          ));
        },
      );

    _expenditureSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('expenditure')
        .snapshots()
        .listen(
      (data) {
        emit(ExpenseListState(
          expenditureListDocuments: data.docs,
          wantSpendDocuments: state.wantSpendDocuments,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            expenditureListDocuments: [],
            errorMessage: error.toString(),
            loadingErrorOccured: true,
          ));
        },
      );
  }

// Dodawanie wydatku --------------------------------add expenditure
  Future<void> addToExpenditureList(expenseName) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userdID)
          .collection('expenditure')
          .add({
        'name': expenseName.text,
      });
    } catch (error) {
      emit(ExpenseListState(
          addErrorOccured: true, errorMessage: error.toString()));
      start();
    }
  }

// usuwanie wydatku --------------------------- remove expenditure
  Future<void> removePositionOnExpenditureList({required String id}) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userdID)
          .collection('expenditure')
          .doc(id)
          .delete();
    } catch (error) {
      emit(ExpenseListState(
          removeErrorOccured: true, errorMessage: error.toString()));
      start();
    }
  }

  @override
  Future<void> close() {
    _wannaspendSubscription?.cancel();
    _expenditureSubscription?.cancel();
    return super.close();
  }
}
