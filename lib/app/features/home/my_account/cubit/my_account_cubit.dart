import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'my_account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit()
      : super(
          MyAccountState(loading: false),
        );

  StreamSubscription? _streamSubscription;
  Future<void> start() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      MyAccountState(loading: true),
    );
    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userdID)
        .collection('wantspend')
        .snapshots()
        .listen(
      (data) {
        emit(
          MyAccountState(documents: data.docs),
        );
      },
    )..onError((error) {
        emit(
          MyAccountState(errorMessage: error),
        );
      });
  }

  Future<void> remove({required id}) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userdID)
          .collection('wantspend')
          .doc(id)
          .delete();
    } catch (error) {
      emit(MyAccountState(errorMessage: error.toString()));
    }
    start();
  }

  Future<void> addSubtractionResult({
    required earningsController,
    required savingsController,
    var result,
    var earningControllerValue,
    var savingsControllerValue,
  }) async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }

    earningControllerValue = int.parse(earningsController);
    savingsControllerValue = int.parse(savingsController);
    result = earningControllerValue - savingsControllerValue;

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userdID)
          .collection('wantspend')
          .add(
        {
          'value': result,
          'saving': savingsControllerValue,
        },
      );
    } catch (error) {
      emit(MyAccountState(errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
