import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skarbonka_v2/app/cubit/root_cubit.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/page/expense_list_page_content.dart';
import 'package:skarbonka_v2/app/features/home/reminders/Page/reminders_page_content.dart';
import 'package:skarbonka_v2/app/features/home/my_account/page/my_account_page_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skarbonka_v2/app/my_app/services/notification_services.dart';
import 'package:skarbonka_v2/app/my_app/services/theme_services.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required this.user,
  });

  final User user;
  final earningsController = TextEditingController();
  final savingsController = TextEditingController();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 1;
  final notifyHelper = NotifyHelper();

  @override
  void initState() {
    super.initState();

    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  // @override
  // void dispose() {

  //   super.dispose();
  //   notifyHelper.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar(context, notifyHelper),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Przypomnienie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Wydatki',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Konto',
          ),
        ],
      ),
      // ConvexAppBar(
      //   backgroundColor: Colors.orange,
      //   color: Colors.white,
      //   activeColor: Colors.orange[900],
      //   shadowColor: Colors.black,
      //   initialActiveIndex: selectedIndex,
      //   onTap: (value) {
      //     setState(() {
      //       selectedIndex = value;
      //     });
      //   },
      //   items: const [
      //     TabItem(
      //       icon: Icon(
      //         Icons.bar_chart_rounded,
      //         color: Colors.white,
      //       ),
      //       title: 'Raport wydatków',
      //     ),
      //     TabItem(
      //       icon: Icon(
      //         Icons.home_outlined,
      //         color: Colors.white,
      //       ),
      //       title: 'Strona główna',
      //     ),
      //     TabItem(
      //       icon: Icon(
      //         Icons.person,
      //         color: Colors.white,
      //       ),
      //       title: 'Moje konto',
      //     ),
      //   ],
      // ),
      body: Builder(builder: (context) {
        if (selectedIndex == 0) {
          return const ReminderPageContent();
        }

        if (selectedIndex == 1) {
          return const ExpenseListPageContent();
        }

        return MyAccountPageContent(email: widget.user.email);
      }),
    );
  }
}

_myAppBar(BuildContext context, notifyHelper) {
  return AppBar(
    backgroundColor:
        Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
    leading: InkWell(
      onTap: () {
        ThemeServices().switchThemeMode();
        notifyHelper.displayNotification(
            title: 'Zmiana motywu',
            body: Get.isDarkMode
                ? 'Aktywowano jasny motyw'
                : 'Aktywowano ciemny motyw');
        // notifyHelper.scheduledNotification();
      },
      child: const Icon(
        Icons.nightlight_round,
      ),
    ),
    centerTitle: true,
    title: Text(
      '#Skarbonka',
      style: GoogleFonts.pacifico(
          color: Get.isDarkMode ? Colors.white54 : Colors.black38,
          fontSize: 30,
          fontStyle: FontStyle.italic),
    ),
    actions: [
      IconButton(
          onPressed: () {
            context.read<RootCubit>().signOut();
          },
          icon: const Icon(
            Icons.logout,
          ))
    ],
  );
}
