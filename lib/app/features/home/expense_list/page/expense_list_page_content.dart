import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skarbonka_v2/app/features/home/add_expense/page/add_expense_page_content.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/cubit/expense_list_cubit.dart';
import 'package:skarbonka_v2/app/my_app/text_style/text_style.dart';
import 'package:skarbonka_v2/app/my_app/widgets/expenditure_widget.dart';
import 'package:skarbonka_v2/app/repositories/expenditure_repository.dart';
import 'package:skarbonka_v2/app/repositories/want_spend_repository.dart';

class ExpenseListPageContent extends StatefulWidget {
  const ExpenseListPageContent({
    super.key,
  });

  @override
  State<ExpenseListPageContent> createState() => _ExpenseListPageContentState();
}

class _ExpenseListPageContentState extends State<ExpenseListPageContent> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) =>
          ExpenseListCubit(ExpenditureRepository(), WantspendRepository())
            ..start(),
      child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.errorMessage.isNotEmpty) {
            return Center(
                child: Text('Something went wrong: ${state.errorMessage}'));
          }

          final expenditureListItemModels = state.expenditureListDocuments;
          final wantSpendItemModels = state.wantSpendDocuments;

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddExpensePageContent(),
                  ),
                );
              },
              backgroundColor: Colors.orange,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: Center(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        width: width * 0.8,
                        height: height * 0.050,
                        margin: const EdgeInsets.only(
                            right: 10, left: 10, top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            DateFormat.yMMMMEEEEd('pl').format(DateTime.now()),
                            style: getDateTextStyleInExpenseList(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: width,
                        height: height * 0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('images/shrek.png'),
                              radius: 60,
                            ),
                            Container(
                              width: width * 0.60,
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text(
                                      'Do wydania:',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      for (final itemModel
                                          in wantSpendItemModels) ...{
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            '${itemModel.value} PLN',
                                            style: const TextStyle(
                                                fontSize: 27,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      }
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          for (final itemModel
                              in expenditureListItemModels) ...[
                            Dismissible(
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete),
                              ),
                              key: ValueKey(itemModel.id),
                              child: ExpenditureWidget(
                                  width: width,
                                  height: height,
                                  expenditure: itemModel.name,
                                  cost: itemModel.cost),
                              onDismissed: (direction) {
                                context
                                    .read<ExpenseListCubit>()
                                    .removePositionOnExpenditureList(
                                        documentId: itemModel.id);
                              },
                              confirmDismiss: (direction) async {
                                return direction == DismissDirection.endToStart;
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
