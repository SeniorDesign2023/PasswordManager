import 'package:flutter/material.dart';
import 'package:app/UILibrary.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UILibrary.landingPageAuthPageBar(context),
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text('Please log in or sign up'),
        Padding(
            padding: EdgeInsets.all(150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Login')),
                Container(
                  width: 50,
                  color: Colors.transparent,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text('Sign up'))
              ],
            ))
      ],
    ));
  }
}
