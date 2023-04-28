import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
  final _signupFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signupFormKey,
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
