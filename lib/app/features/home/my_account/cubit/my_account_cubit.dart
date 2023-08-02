import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/models/want_spend_model.dart';
import 'package:skarbonka_v2/app/repositories/want_spend_repository.dart';
part 'my_account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  MyAccountCubit(this._wantspendRepository)
      : super(
          MyAccountState(loading: false),
        );

  final WantspendRepository _wantspendRepository;
  StreamSubscription? _streamSubscription;
  Future<void> start() async {
    _streamSubscription = _wantspendRepository.getWantSpendStream().listen(
      (wantspendData) {
        emit(
          MyAccountState(wantSpendDocuments: wantspendData),
        );
      },
    )..onError((error) {
        emit(
          MyAccountState(errorMessage: error),
        );
      });
  }

  Future<void> remove({required documentId}) async {
    try {
      await _wantspendRepository.removeWantspend(documentID: documentId);
    } catch (error) {
      emit(MyAccountState(errorMessage: error.toString()));
    }
    start();
  }

  Future<void> addSubtractionResult({
    required earningsController,
    required savingsController,
    var result,
    var addEarningControllerValue,
    var savingsControllerValue,
  }) async {
    try {
      await _wantspendRepository.addtWantspend(
          addEarningsController: earningsController,
          addSavingsController: savingsController);
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
