import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Please log in or sign up'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  debugPrint("login button pressed");
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login')),
            ElevatedButton(
                onPressed: () {
                  debugPrint("sign up button pressed");
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Sign up'))
          ],
        )
      ],
    ));
  }
}
