import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/models/reminder_model.dart';
import 'package:skarbonka_v2/app/repositories/reminder_repository.dart';
part 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(this._reminderRepository)
      : super(RemindersState(
          isLoading: true,
        ));

  StreamSubscription? _streamSubscription;
  final ReminderRepository _reminderRepository;

  Future<void> start() async {
    _streamSubscription = _reminderRepository.getReminderStream().listen(
      (reminderDocuments) {
        emit(RemindersState(
          documentsFromTheReminderModel: reminderDocuments,
          isLoading: false,
        ));
      },
    )..onError(
        (error) {
          emit(RemindersState(
            errorMessage: error,
          ));
        },
      );
  }

  Future<void> delete({required String documentID}) async {
    try {
      _reminderRepository.removeReminder(documentID: documentID);
    } catch (error) {
      emit(RemindersState(errorMessage: error.toString()));
      start();
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
