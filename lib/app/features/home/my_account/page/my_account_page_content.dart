import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skarbonka_v2/app/features/home/my_account/cubit/my_account_cubit.dart';

class MyAccountPageContent extends StatefulWidget {
  const MyAccountPageContent({
    super.key,
    required this.email,
  });

  final String? email;

  @override
  State<MyAccountPageContent> createState() => _MyAccountPageContentState();
}

var earningsController = '';
var savingsController = '';
var isCreatingValue = false;
var hiden = true;

class _MyAccountPageContentState extends State<MyAccountPageContent> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => MyAccountCubit()..start(),
      child: BlocListener<MyAccountCubit, MyAccountState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<MyAccountCubit, MyAccountState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.errorMessage.isNotEmpty) {
              return Center(
                child: Text('Something went wrong: ${state.errorMessage}'),
              );
            }
            final documents = state.documents;
            return Center(
              child: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: width,
                        height: height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Używasz konta: ',
                            ),
                            Text(
                              '${widget.email}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('images/shrek.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                color: Colors.orange,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add_a_photo_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: width,
                        child: Column(
                          children: [
                            if (isCreatingValue == true)
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      earningsController = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    label: const Text(
                                      'Zarabiam',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    hintText: 'Podaj swoje wynagrodzenie.',
                                    suffixIcon: const Icon(Icons.paid,
                                        color:
                                            Color.fromARGB(255, 222, 174, 0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                              ),
                            if (isCreatingValue == true)
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      savingsController = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    label: const Text(
                                      'Oszczędzam',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    hintText:
                                        'Podaj kwote jaką chcesz zaoszczędzić.',
                                    suffixIcon: const Icon(Icons.savings,
                                        color:
                                            Color.fromARGB(255, 222, 174, 0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                              ),
                            Column(
                              children: [
                                if (documents != null)
                                  for (final document in documents) ...[
                                    if (isCreatingValue == false)
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.all(5),
                                        width: width * 0.8,
                                        height: height * 0.10,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.orange),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text(
                                                'Miesięcznie do wydania mam: '),
                                            Text(
                                              '${document.value} PLN',
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      width: width * 0.8,
                                      height: height * 0.10,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.orange),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                              'Miesięcznie oszczędzam: '),
                                          Text(
                                            '${document.saving} PLN',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Color.fromARGB(
                                                    255, 24, 131, 28),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isCreatingValue == false)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              context
                                                  .read<MyAccountCubit>()
                                                  .remove(
                                                      documentId: document.id);
                                              isCreatingValue = true;
                                            });
                                          },
                                          child: const Text(
                                            'Zmień',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                  ],
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          if (isCreatingValue == true) ...[
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<MyAccountCubit>()
                                        .addSubtractionResult(
                                            earningsController:
                                                earningsController,
                                            savingsController:
                                                savingsController);

                                    isCreatingValue = false;
                                  });
                                },
                                child: const Text('Zapisz'),
                              ),
                            ),
                          ],
                          if (hiden == true)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isCreatingValue = true;
                                  hiden = false;
                                });
                              },
                              child: const Text('Ustaw ile chcesz oszczędzać'),
                            )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
