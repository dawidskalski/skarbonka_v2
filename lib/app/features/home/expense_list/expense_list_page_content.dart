import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/features/home/expense_list/cubit/expense_list_cubit.dart';

class ExpenseListPageContent extends StatefulWidget {
  const ExpenseListPageContent({
    super.key,
  });

  @override
  State<ExpenseListPageContent> createState() => _ExpenseListPageContentState();
}

class _ExpenseListPageContentState extends State<ExpenseListPageContent> {
  var expenseName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            final alert = AlertDialog(
              actions: [
                BlocProvider(
                  create: (context) => ExpenseListCubit(),
                  child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () {
                          context
                              .read<ExpenseListCubit>()
                              .addExpenditure(expenseName);

                          expenseName.clear();

                          Navigator.of(context)
                              .pop(const ExpenseListPageContent());
                        },
                        child: const Text('Dodaj'),
                      );
                    },
                  ),
                ),
              ],
              title: const Text('Rodzaj wydatku'),
              content: TextField(
                controller: expenseName,
                decoration: const InputDecoration(
                  label: Text('Wydatek'),
                  hintText: 'np:.. Rachunki',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
              ),
            );
            showDialog(
              context: context,
              builder: (_) {
                return alert;
              },
            );
          },
          child: const Icon(Icons.add)),
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
                            BlocProvider(
                              create: (context) =>
                                  ExpenseListCubit()..wantspend(),
                              child: BlocBuilder<ExpenseListCubit,
                                  ExpenseListState>(
                                builder: (context, state) {
                                  if (state.errorMessage.isNotEmpty) {
                                    return Text(
                                        'Something went wrong: ${state.errorMessage}');
                                  }

                                  if (state.loading) {
                                    return const CircularProgressIndicator();
                                  }

                                  final documents = state.documents;

                                  return Column(
                                    children: [
                                      for (final document in documents!) ...[
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            '${document['value']} PLN',
                                            style: const TextStyle(
                                                fontSize: 27,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                BlocProvider(
                  create: (context) => ExpenseListCubit()..expenditure(),
                  child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
                    builder: (context, state) {
                      if (state.errorMessage.isNotEmpty) {
                        return Center(
                            child: Text(
                                'Something went wrong: ${state.errorMessage}'));
                      }

                      if (state.loading) {
                        return const CircularProgressIndicator();
                      }

                      final documents = state.documents;
                      return Column(
                        children: [
                          for (final document in documents!) ...[
                            Dismissible(
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete),
                              ),
                              key: ValueKey(document.id),
                              child: ExpenditureWidget(
                                width: width,
                                height: height,
                                doc: document['name'],
                              ),
                              onDismissed: (direction) {
                                context
                                    .read<ExpenseListCubit>()
                                    .remove(id: document.id);
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenditureWidget extends StatelessWidget {
  ExpenditureWidget({
    super.key,
    required this.width,
    required this.height,
    required this.doc,
  });

  final double width;
  final double height;
  final String doc;
  final concreteExpense = TextEditingController();
  final cost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(15),
            ),
            border: Border.all(color: Colors.orange)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.12,
                  height: height * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                SizedBox(
                  width: width * 0.5,
                  height: height * 0.06,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        doc,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.orange),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  width: width * 0.20,
                  height: height * 0.06,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          '0 PLN',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
