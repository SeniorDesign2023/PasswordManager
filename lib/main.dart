import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}

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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [LoginForm()],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 10),
                    borderRadius: BorderRadius.circular(5))),
            validator: (uname) {
              if (uname == null || uname.isEmpty) {
                return 'Please enter a username';
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 10),
                    borderRadius: BorderRadius.circular(5))),
            validator: (pass) {
              if (pass == null || pass.isEmpty) {
                return 'Please enter a password';
              }
            },
          ),
          ElevatedButton(
              onPressed: () => print('submit button pressed'),
              child: Text('Submit'))
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [SignUpForm()],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 10),
                    borderRadius: BorderRadius.circular(5))),
            validator: (uname) {
              if (uname == null || uname.isEmpty) {
                return 'Please enter a username';
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 10),
                    borderRadius: BorderRadius.circular(5))),
            validator: (pass) {
              if (pass == null || pass.isEmpty) {
                return 'Please enter a password';
              }
            },
          ),
          ElevatedButton(
              onPressed: () => print('submit button pressed'),
              child: Text('Submit'))
        ],
      ),
    );
  }
}
