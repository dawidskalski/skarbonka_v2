import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'my_account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit()
      : super(
          MyAccountState(
            documents: [],
            errorMessage: '',
            loading: false,
          ),
        );

  StreamSubscription? _streamSubscription;
  Future<void> start() async {
    final userdID = FirebaseAuth.instance.currentUser?.uid;
    if (userdID == null) {
      throw Exception('error');
    }
    emit(
      MyAccountState(
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
        emit(
          MyAccountState(
            documents: data.docs,
            errorMessage: '',
            loading: false,
          ),
        );
      },
    )..onError((error) {
        emit(
          MyAccountState(
            documents: [],
            errorMessage: error,
            loading: false,
          ),
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
      emit(MyAccountState(
          documents: [], errorMessage: error.toString(), loading: false));
    }
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
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
