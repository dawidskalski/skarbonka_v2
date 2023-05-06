import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit()
      : super(ExpenseListState(
          documents: [],
          errorMessage: '',
          loading: false,
        ));

  StreamSubscription? _streamSubscription;

//Do wydania --------------------------------------wantspend
  Future<void> wantspend() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      ExpenseListState(
        documents: [],
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
          documents: data.docs,
          errorMessage: '',
          loading: false,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            documents: [],
            errorMessage: error.toString(),
            loading: false,
          ));
        },
      );
  }

  //Lista wydatków --------------------------------------expenditure
  Future<void> expenditure() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      ExpenseListState(
        documents: [],
        errorMessage: '',
        loading: true,
      ),
    );

    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('expenditure')
        .snapshots()
        .listen(
      (data) {
        emit(ExpenseListState(
          documents: data.docs,
          errorMessage: '',
          loading: false,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            documents: [],
            errorMessage: error.toString(),
            loading: false,
          ));
        },
      );
  }

// Dodawanie wydatku --------------------------------add expenditure
  Future<void> addExpenditure(expenseName) async {
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
          documents: null, errorMessage: error.toString(), loading: false));
    }
  }

// usuwanie wydatku --------------------------- remove expenditure
  Future<void> remove({required String id}) async {
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
