import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/models/expense_model.dart';
part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit()
      : super(
          ExpenseListState(loading: false),
        );
  StreamSubscription? _wannaspendSubscription;
  StreamSubscription? _expenditureSubscription;

  Future<void> start() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      ExpenseListState(loading: true),
    );

    _wannaspendSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('wantspend')
        .snapshots()
        .listen(
      (data) {
        final itemModelsWantSpend = data.docs.map((doc) {
          return ExpenseModel(
            id: doc.id,
            saving: doc['saving'],
            value: doc['value'],
          );
        }).toList();
        emit(ExpenseListState(
          wantSpendDocuments: itemModelsWantSpend,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            errorMessage: error,
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
        final itemModelsExpenditure = data.docs.map((doc) {
          return ExpenseModel(
            id: doc.id,
            name: doc['name'],
          );
        }).toList();
        emit(ExpenseListState(
          expenditureListDocuments: itemModelsExpenditure,
          wantSpendDocuments: state.wantSpendDocuments,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            errorMessage: error,
          ));
        },
      );
  }

// usuwanie wydatku --------------------------- remove expenditure
  Future<void> removePositionOnExpenditureList(
      {required String documentId}) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userdID)
          .collection('expenditure')
          .doc(documentId)
          .delete();
    } catch (error) {
      emit(ExpenseListState(errorMessage: error.toString()));
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
