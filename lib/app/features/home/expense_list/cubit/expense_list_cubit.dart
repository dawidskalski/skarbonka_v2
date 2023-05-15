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
          loading: false,
        ));

  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      ExpenseListState(
        expenditureListDocuments: [],
        wantSpendDocuments: [],
        errorMessage: '',
        loading: true,
      ),
    );

    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('wantspend')
        .snapshots()
        .listen(
      (data) {
        emit(ExpenseListState(
          wantSpendDocuments: data.docs,
          expenditureListDocuments: [],
          errorMessage: '',
          loading: false,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            wantSpendDocuments: [],
            expenditureListDocuments: [],
            errorMessage: error.toString(),
            loading: false,
          ));
        },
      );

    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('expenditure')
        .snapshots()
        .listen(
      (data) {
        emit(ExpenseListState(
          expenditureListDocuments: data.docs,
          wantSpendDocuments: [],
          errorMessage: '',
          loading: false,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            expenditureListDocuments: [],
            wantSpendDocuments: [],
            errorMessage: error.toString(),
            loading: false,
          ));
        },
      );
  }

  //Lista wydatków  --------------------------------------expenditure
  // Future<void> expenditureListStart() async {
  //   final userdID = FirebaseAuth.instance.currentUser?.uid;
  //   if (userdID == null) {
  //     throw Exception('error');
  //   }
  //   emit(
  //     ExpenseListState(
  //       documents: [],
  //       errorMessage: '',
  //       loading: true,
  //     ),
  //   );

  // }

// Dodawanie wydatku --------------------------------add expenditure
  Future<void> addToExpenditureList(expenseName) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('expenditure')
        .add({
      'name': expenseName.text,
    });
  }

// usuwanie wydatku --------------------------- remove expenditure
  Future<void> removePositionOnExpenditureList({required String id}) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('expenditure')
        .doc(id)
        .delete();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
