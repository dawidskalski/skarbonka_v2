import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/features/home/add_expense/page/add_expense_page_content.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/cubit/expense_list_cubit.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/widgets/expenditure_widget.dart';
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
                      fullscreenDialog: true),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: Center(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        width: width,
                        height: height * 0.050,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_left),
                            ),
                            const Text('Data'),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_right),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
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
                                          in wantSpendItemModels)
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
                                cost: itemModel.cost
                              ),
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
