import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/models/expenditure_model.dart';
import 'package:skarbonka_v2/app/models/want_spend_model.dart';
import 'package:skarbonka_v2/app/repositories/expenditure_repository.dart';
import 'package:skarbonka_v2/app/repositories/want_spend_repository.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit(this._expenditureRepository, this._wantspendRepository)
      : super(
          ExpenseListState(loading: false),
        );

  final ExpenditureRepository _expenditureRepository;
  final WantspendRepository _wantspendRepository;
  StreamSubscription? _wannaspendSubscription;
  StreamSubscription? _expenditureSubscription;

  Future<void> start() async {
    _wannaspendSubscription = _wantspendRepository.getWantSpendStream().listen(
      (wantspendData) {
        emit(ExpenseListState(
          wantSpendDocuments: wantspendData,
        ));
      },
    )..onError(
        (error) {
          emit(ExpenseListState(
            errorMessage: error,
          ));
        },
      );

    _expenditureSubscription =
        _expenditureRepository.getExpenditureStream().listen(
      (expenditureData) {
        emit(ExpenseListState(
          expenditureListDocuments: expenditureData,
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
    try {
      await _expenditureRepository.removeExpenditure(documentID: documentId);
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
