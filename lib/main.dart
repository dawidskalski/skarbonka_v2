import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skarbonka_v2/app/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
