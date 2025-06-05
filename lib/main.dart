import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialmediataskapp/screens/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Notes App',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
