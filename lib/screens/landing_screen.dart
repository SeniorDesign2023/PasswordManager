import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/UILibrary.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //print(FirebaseAuth.instance.currentUser);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Password Manager!")
        ),
        backgroundColor: ColourTheme.appBarBackground
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text('Please log in or sign up'),
        Padding(
            padding: const EdgeInsets.all(150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login')),
                Container(
                  width: 50,
                  color: Colors.transparent,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Sign up'))
              ],
            )
          )
        ],
      )
    );
  }
}
