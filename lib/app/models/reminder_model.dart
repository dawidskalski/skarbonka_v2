import 'package:intl/intl.dart';

class ReminderModel {
  final String id;
  final String title;
  final String note;
  final DateTime date;
  final String time;
  final String color;
  final String whenToRemind;

  ReminderModel(
      {required this.id,
      required this.title,
      required this.note,
      required this.date,
      required this.time,
      required this.color,
      required this.whenToRemind});

  String formattedReleaseDate() {
    return DateFormat.yMMMMEEEEd('pl').format(date);
  }
}
