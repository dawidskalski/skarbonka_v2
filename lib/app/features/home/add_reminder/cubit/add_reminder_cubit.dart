import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/repositories/reminder_repository.dart';
part 'add_reminder_state.dart';

class AddReminderCubit extends Cubit<AddReminderState> {
  AddReminderCubit(this._reminderRepository) : super(AddReminderState());

  final ReminderRepository _reminderRepository;

  Future<void> addtoReminderList({
    required String title,
    required String note,
    required DateTime date,
    required String time,
    required String color,
    required String whenToRemind,
  }) async {
    try {
      _reminderRepository.addReminder(
        title: title,
        note: note,
        date: date,
        time: time,
        color: color,
        whenToRemind: whenToRemind,
      );
      emit(AddReminderState(isSaved: true));
    } catch (error) {
      emit(AddReminderState(errorMessage: error.toString()));
    }
  }
}
