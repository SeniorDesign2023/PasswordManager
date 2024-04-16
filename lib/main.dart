import 'package:app/UILibrary.dart';
import 'package:app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //print("started");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //print("firebase init done");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  //Changing theme
  void changeTheme() {
    ColourTheme.updateTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ColourTheme.theme,
      initialRoute: '/',
      routes: UILibrary.routes,
    );
  }
}
