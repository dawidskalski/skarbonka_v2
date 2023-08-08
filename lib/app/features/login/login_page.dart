import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
  });

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgetPasswordController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var errorMessage = '';
  var creatingAccount = false;
  var forgetAccount = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: width,
                height: height * 0.2,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  image: DecorationImage(image: AssetImage('images/piggy.png')),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (forgetAccount == false)
                      Text(
                        'Hej!',
                        style: GoogleFonts.lato(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (forgetAccount == false)
                      Text(
                        creatingAccount == false
                            ? 'Zaloguj się'
                            : 'Zarejestruj się',
                        style: GoogleFonts.lato(
                          fontSize: 30,
                        ),
                      ),
                    if (forgetAccount == true)
                      Text(
                        'Podaj maila aby przypomnieć hasło',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    if (forgetAccount == false)
                      Row(
                        children: [
                          Text(
                            creatingAccount == false
                                ? 'Nie masz jeszcze konta?'
                                : 'Przecież',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (creatingAccount == false) {
                                return setState(() {
                                  creatingAccount = true;
                                });
                              }

                              return setState(() {
                                creatingAccount = false;
                              });
                            },
                            child: Text(
                              creatingAccount == false
                                  ? 'Zarejestruj się'
                                  : 'Mam już konto!',
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 50),
                    if (forgetAccount == true)
                      TextField(
                        controller: widget.forgetPasswordController,
                        decoration: InputDecoration(
                          label: Text(
                            'e-mail',
                            style: GoogleFonts.lato(),
                          ),
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: Colors.deepOrangeAccent,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    if (forgetAccount == false)
                      TextField(
                        controller: widget.emailController,
                        decoration: InputDecoration(
                          label: Text(
                            'e-mail',
                            style: GoogleFonts.lato(),
                          ),
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: Colors.deepOrangeAccent,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (forgetAccount == false)
                      TextField(
                        controller: widget.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text(
                            'Hasło',
                            style: GoogleFonts.lato(),
                          ),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.deepOrangeAccent,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () async {
                  if (forgetAccount == false) {
                    if (creatingAccount == false) {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
                        );
                      } catch (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                      }
                    }
                  }
                  if (forgetAccount == false) {
                    if (creatingAccount == true) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: widget.emailController.text,
                                password: widget.passwordController.text);
                      } catch (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                      }
                    }
                  }

                  if (forgetAccount == true) {
                    // var forgetMail =
                    //     widget.forgetPasswordController.text.trim();
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: widget.forgetPasswordController.text.trim());
                    widget.forgetPasswordController.clear;

                    setState(() {
                      forgetAccount = false;
                    });
                  }
                },
                icon: const Icon(
                  Icons.arrow_right_alt,
                ),
                iconSize: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    forgetAccount == false
                        ? 'Nie pamiętasz hasła ?'
                        : 'Pamiętam hasło',
                    style: GoogleFonts.lato(color: Colors.grey, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      if (forgetAccount == false) {
                        return setState(() {
                          forgetAccount = true;
                        });
                      }

                      if (forgetAccount == true) {
                        return setState(() {
                          forgetAccount = false;
                        });
                      }
                    },
                    child: Text(
                      forgetAccount == false
                          ? 'Przypomnij hasło'
                          : 'Wróć do logowania',
                      style: GoogleFonts.lato(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
