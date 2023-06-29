import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/cubit/root_cubit.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/page/expense_list_page_content.dart';
import 'package:skarbonka_v2/app/features/home/reminders/reminders_page_content.dart';
import 'package:skarbonka_v2/app/features/home/my_account/page/my_account_page_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        leading: Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          // child: const CircleAvatar(
          //   backgroundImage: AssetImage('images/piggy.png'),
          // ),
        ),
        centerTitle: true,
        title: Text(
          '#Skarbonka',
          style: GoogleFonts.dancingScript(color: Colors.white, fontSize: 40),
        ),
        actions: [
          IconButton(
              color: Colors.orange,
              onPressed: () {
                context.read<RootCubit>().signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.orange,
        color: Colors.white,
        activeColor: Colors.orange[900],
        shadowColor: Colors.black,
        initialActiveIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          TabItem(
            icon: Icon(
              Icons.bar_chart_rounded,
              color: Colors.white,
            ),
            title: 'Raport wydatków',
          ),
          TabItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            title: 'Strona główna',
          ),
          TabItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: 'Moje konto',
          ),
        ],
      ),
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
