import 'package:app/firebase_options.dart';
import 'package:app/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/landing_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static String _seed = '';

  void setseed(string) {
    _seed = md5.convert(utf8.encode(string)).toString();
    print(_seed);
  }

  String getseed() => _seed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => LoginScreen(function: setseed),
        '/signup': (context) => SignUpScreen(function: setseed),
        '/user': (context) => UserScreen(function: getseed),
      },
    );
  }
}
