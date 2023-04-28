import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
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
