import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/features/home/add_expense/cubit/add_expense_cubit.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/page/expense_list_page_content.dart';
import 'package:skarbonka_v2/app/repositories/expenditure_repository.dart';

class AddExpensePageContent extends StatefulWidget {
  const AddExpensePageContent({
    super.key,
  });

  @override
  State<AddExpensePageContent> createState() => _AddExpensePageContentState();
}

class _AddExpensePageContentState extends State<AddExpensePageContent> {
  late TextEditingController expenseNameController;
  late TextEditingController costController;
  var isButtonEnabledOne = false;
  var isButtonEnabledTwo = false;

  @override
  void initState() {
    super.initState();
    expenseNameController = TextEditingController();
    expenseNameController.addListener(
      () {
        if (expenseNameController.text.isNotEmpty) {
          setState(() {
            isButtonEnabledOne = true;
          });
        } else {
          setState(() {
            isButtonEnabledOne = false;
          });
        }
      },
    );

    costController = TextEditingController();
    costController.addListener(() {
      if (costController.text.isNotEmpty) {
        setState(() {
          isButtonEnabledTwo = true;
        });
      } else {
        setState(() {
          isButtonEnabledTwo = false;
        });
      }
    });
  }

  @override
  void dispose() {
    expenseNameController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddExpenseCubit(ExpenditureRepository()),
      child: BlocListener<AddExpenseCubit, AddExpenseState>(
        listener: (context, state) {
          if (state.save == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Dodano!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 26, right: 10, left: 10),
            ));
            Navigator.of(context).pop(const ExpenseListPageContent());
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
        child: BlocBuilder<AddExpenseCubit, AddExpenseState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: true,
                title: const Text('Dodaj wydatek'),
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: expenseNameController,
                      decoration: InputDecoration(
                        label: const Text('Wpisz nazwę wydatku'),
                        hintText: 'np: Jedzenie',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: costController,
                      decoration: InputDecoration(
                        label: const Text('Ile pieniędzy zainwestowano ?'),
                        hintText: 'np: 10 zł',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: isButtonEnabledOne == false ||
                              isButtonEnabledTwo == false
                          ? null
                          : () {
                              context
                                  .read<AddExpenseCubit>()
                                  .addToExpenditureList(
                                      cost: costController.text,
                                      expenseName: expenseNameController.text);

                              expenseNameController.clear();
                              costController.clear();
                            },
                      child: const Text('Dodaj'),
                    ),
                  )
                ],
              )),
            );
          },
        ),
      ),
    );
  }
}
