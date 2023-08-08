import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skarbonka_v2/app/features/home/add_reminder/cubit/add_reminder_cubit.dart';
import 'package:skarbonka_v2/app/features/home/reminders/Page/reminders_page_content.dart';
import 'package:skarbonka_v2/app/my_app/widgets/add_reminder_button_widget.dart';
import 'package:skarbonka_v2/app/repositories/reminder_repository.dart';

@immutable
class AddReminderPageContent extends StatefulWidget {
  const AddReminderPageContent({
    super.key,
  });

  @override
  State<AddReminderPageContent> createState() => _AddReminderPageContentState();
}

final List<String> reminderTypes = [
  'Nigdy',
  'Co godzinę',
  'Codziennie',
  'Co miesiąc'
];

class _AddReminderPageContentState extends State<AddReminderPageContent> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  String selectedColor = 'orange';
  DateTime? mySelectedDate;
  TimeOfDay? mySelectedTime;

  String myReminderType = reminderTypes.first;

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddReminderCubit(ReminderRepository()),
      child: BlocListener<AddReminderCubit, AddReminderState>(
        listener: (context, state) {
          if (state.isSaved == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Dodano"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 30, right: 10, left: 10),
            ));
            Navigator.of(context).pop(const ReminderPageContent());
          }

          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            ));
          }
        },
        child: BlocBuilder<AddReminderCubit, AddReminderState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Pamiętaj o... ',
                        style: GoogleFonts.lato(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _AddReminderField(
                          myHintText: 'np:. Rata ',
                          myLabel: "Tytuł ",
                          myEditingController: _titleController),
                      _AddReminderField(
                          myLabel: 'Notatka',
                          myHintText: "np:. Pamietaj o zapłaceniu raty",
                          myEditingController: _noteController),
                      _MyDatedButton(
                        myDateChanged: (newValue) {
                          setState(() {
                            mySelectedDate = newValue;
                          });
                        },
                        selectedDateFormatted: mySelectedDate == null
                            ? null
                            : DateFormat.yMMMMEEEEd('pl')
                                .format(mySelectedDate!),
                      ),
                      _MyTimeButton(
                        myChangedTime: (timeValue) {
                          setState(() {
                            mySelectedTime = timeValue;
                          });
                        },
                        selectedTimeFormatted: mySelectedTime == null
                            ? 'Godzina'
                            : formatTimeOfDay(mySelectedTime!),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Powtarzać',
                                style: GoogleFonts.lato(
                                    color: Colors.grey[600], fontSize: 17),
                              ),
                              DropdownButton(
                                value: myReminderType,
                                onChanged: (value) {
                                  setState(() {
                                    myReminderType = value!;
                                  });
                                },
                                items:
                                    reminderTypes.map((valueOnReminderTypes) {
                                  return DropdownMenuItem(
                                      value: valueOnReminderTypes,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.orange),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            valueOnReminderTypes,
                                            style: GoogleFonts.lato(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ));
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kolor',
                                  style: GoogleFonts.lato(
                                      color: Colors.grey[600], fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedColor = 'red';
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 17,
                                        child: selectedColor == 'red'
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedColor = 'green';
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 17,
                                        child: selectedColor == 'green'
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedColor = 'blue';
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius: 17,
                                        child: selectedColor == 'blue'
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                )
                              ],
                            ),
                            AddReminderButtonWidget(
                              icon: const Icon(Icons.add, color: Colors.white),
                              giveName: 'Zapisz',
                              onTap: () {
                                context
                                    .read<AddReminderCubit>()
                                    .addtoReminderList(
                                      title: _titleController.text,
                                      note: _noteController.text,
                                      date: mySelectedDate!,
                                      time: mySelectedTime!.format(context),
                                      color: selectedColor,
                                      whenToRemind: myReminderType,
                                    );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MyTimeButton extends StatelessWidget {
  const _MyTimeButton({
    required this.myChangedTime,
    this.selectedTimeFormatted,
  });

  final Function(TimeOfDay?) myChangedTime;
  final String? selectedTimeFormatted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: InkWell(
        onTap: () async {
          final selectedTime = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());

          myChangedTime(selectedTime);
        },
        focusColor: Colors.orange,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedTimeFormatted!,
                      style: GoogleFonts.lato(
                          color: Colors.grey[600], fontSize: 17),
                    ),
                  ],
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyDatedButton extends StatelessWidget {
  const _MyDatedButton({
    required this.myDateChanged,
    this.selectedDateFormatted,
  });

  final Function(DateTime?) myDateChanged;
  final String? selectedDateFormatted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: InkWell(
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now().add(const Duration(days: 360)),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(
              const Duration(days: 365 * 10),
            ),
          );
          myDateChanged(selectedDate);
        },
        focusColor: Colors.orange,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedDateFormatted ?? 'Data',
                      style: GoogleFonts.lato(
                          color: Colors.grey[600], fontSize: 17),
                    ),
                  ],
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddReminderField extends StatelessWidget {
  const _AddReminderField({
    required this.myLabel,
    required this.myHintText,
    this.myEditingController,
  });

  final String myHintText;
  final String myLabel;
  final TextEditingController? myEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: TextField(
              controller: myEditingController,
              style: GoogleFonts.lato(),
              decoration: InputDecoration(
                labelStyle: GoogleFonts.lato(color: Colors.grey[600]),
                hintText: myHintText,
                label: Text(myLabel),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
