import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skarbonka_v2/app/features/home/my_account/cubit/my_account_cubit.dart';
import 'package:skarbonka_v2/app/repositories/profile_image_repository.dart';
import 'package:skarbonka_v2/app/repositories/want_spend_repository.dart';

class MyAccountPageContent extends StatefulWidget {
  const MyAccountPageContent({
    super.key,
    required this.email,
  });

  final String? email;

  @override
  State<MyAccountPageContent> createState() => _MyAccountPageContentState();
}

final earningsController = TextEditingController();
final savingsController = TextEditingController();
var isCreatingValue = false;
var hiden = true;

class _MyAccountPageContentState extends State<MyAccountPageContent> {
  // Uint8List? image;
  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => MyAccountCubit(WantspendRepository())..start(),
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
            final wantSpendItemModels = state.wantSpendDocuments;
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
                          // if (image != null)
                          CircleAvatar(
                            radius: 64,
                          ),
                          // if (image == null)
                          CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.grey.shade400,
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: -0,
                            right: -0,
                            child: CircleAvatar(
                              backgroundColor: Get.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          selectedAddPicMethod());
                                },
                                icon: Icon(
                                  // image == null
                                  //     ? Icons.add_a_photo_outlined :
                                  Icons.edit,
                                  color: Colors.orange,
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
                                  controller: earningsController,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      'Zarabiam',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    hintText: 'Podaj swoje wynagrodzenie.',
                                    suffixIcon: const Icon(Icons.paid,
                                        color: Colors.orange),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            if (isCreatingValue == true)
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: TextField(
                                  controller: savingsController,
                                  decoration: InputDecoration(
                                    label: const Text(
                                      'Oszczędzam',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    hintText:
                                        'Podaj kwote jaką chcesz zaoszczędzić.',
                                    suffixIcon: const Icon(Icons.savings,
                                        color: Colors.orange),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            Column(
                              children: [
                                for (final document in wantSpendItemModels) ...[
                                  if (isCreatingValue == false)
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
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
                                      border: Border.all(color: Colors.orange),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text('Miesięcznie oszczędzam: '),
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
                                          style: TextStyle(color: Colors.white),
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
                                                earningsController.text,
                                            savingsController:
                                                savingsController.text);

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

  selectedAddPicMethod() {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              'Wybierz zdjęcie profilowe',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            print('Aparat');
                            takePhoto(ImageSource.camera);
                          });
                        },
                        iconSize: 45,
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        'Aparat',
                        style: GoogleFonts.lato(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 65,
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            print('Galeria');
                            takePhoto(ImageSource.gallery);
                          });
                        },
                        iconSize: 45,
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        'Galeria',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, color: Colors.orange),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> takePhoto(ImageSource source) async {}
}
