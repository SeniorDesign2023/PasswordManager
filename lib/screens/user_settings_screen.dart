import 'package:flutter/material.dart';
import 'package:app/UILibrary.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => Settings();
}

class Settings extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Manager"),
        backgroundColor: ColourTheme.appBarBackground,
      ),
      drawer: UILibrary.drawer(context),
      body: const Text("Settings")
    );
  }
}