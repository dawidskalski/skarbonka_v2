import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skarbonka_v2/app/features/home/add_reminder/page/add_reminder_page_content.dart';
import 'package:skarbonka_v2/app/features/home/reminders/cubit/reminders_cubit.dart';
import 'package:skarbonka_v2/app/my_app/text_style/text_style.dart';
import 'package:skarbonka_v2/app/my_app/widgets/add_reminder_button_widget.dart';
import 'package:skarbonka_v2/app/repositories/reminder_repository.dart';

class ReminderPageContent extends StatefulWidget {
  const ReminderPageContent({
    super.key,
  });

  @override
  State<ReminderPageContent> createState() => _ReminderPageContentState();
}

class _ReminderPageContentState extends State<ReminderPageContent> {
  DateTime selectionDate = DateTime.now();
  String selectedColor = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RemindersCubit(ReminderRepository())..start(),
      child: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (context, state) {
          if (state.isLoading == true) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage.isNotEmpty) {
            Center(child: Text('Domtehing went wrong: ${state.errorMessage}'));
          }

          final documentsFromTheItemModels =
              state.documentsFromTheReminderModel;
          return ListView(
            children: [
              _addReminderBar(context, selectedColor),
              _dateBar(context, selectedColor),
              const SizedBox(height: 30),
              Column(
                children: [
                  for (final documentFromTheItemModel
                      in documentsFromTheItemModels) ...{
                    Dismissible(
                      key: Key(documentFromTheItemModel.id),
                      background: const Icon(Icons.delete),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: documentFromTheItemModel.color == 'orange'
                                ? Colors.orange
                                : documentFromTheItemModel.color == 'red'
                                    ? Colors.red
                                    : documentFromTheItemModel.color == 'green'
                                        ? Colors.green
                                        : Colors.blue),
                        child: Column(
                          children: [
                            Text(
                              documentFromTheItemModel.title,
                              style: GoogleFonts.lato(fontSize: 27),
                            ),
                            Text(documentFromTheItemModel.note),
                            Text(documentFromTheItemModel
                                .formattedReleaseDate()),
                            Text(documentFromTheItemModel.time),
                            Row(
                              children: [
                                Text(
                                    'Powtarzać: ${documentFromTheItemModel.whenToRemind}')
                              ],
                            )
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        context
                            .read<RemindersCubit>()
                            .delete(documentID: documentFromTheItemModel.id);
                      },
                      confirmDismiss: (direction) async {
                        return direction == DismissDirection.endToStart;
                      },
                    ),
                  },
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

_addReminderBar(
  BuildContext context,
  String selectedColor,
) {
  return Container(
    margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              width: 190,
              child: Text(
                DateFormat.yMMMMEEEEd('pl').format(DateTime.now()),
                style: getMyHeadingStyle(),
              ),
            ),
            Text(
              'Dziś',
              style: getMySubheaderStyle(),
            )
          ],
        ),
        AddReminderButtonWidget(
          giveName: '  Przypomnienie',
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddReminderPageContent(),
              ),
            );
          },
        ),
      ],
    ),
  );
}

_dateBar(BuildContext context, selectionDate) {
  return Localizations.override(
      context: context,
      locale: const Locale('pl'),
      child: Builder(builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 20, left: 10),
          child: DatePicker(
            DateTime.now(),
            height: 100,
            width: 90,
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.orange,
            dateTextStyle: getDateTextStyle(),
            dayTextStyle: getDayTextStyle(),
            monthTextStyle: getMonthTextStyle(),
            onDateChange: (selectedDate) {
              selectionDate = selectedDate;
            },
          ),
        );
      }));
}
