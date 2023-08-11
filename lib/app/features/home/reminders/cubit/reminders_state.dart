part of 'reminders_cubit.dart';

class RemindersState {
  final List<ReminderModel> documentsFromTheReminderModel;
  final String errorMessage;
  final bool isLoading;

  RemindersState({
    this.documentsFromTheReminderModel = const [],
    this.errorMessage = '',
    this.isLoading = false,
  });
}
