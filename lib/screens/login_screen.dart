import 'package:app/UILibrary.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, required this.function}) : super(key: key);

  Function function;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UILibrary.userAuthPageBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [LoginForm(function: function)],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({super.key, required this.function});

  Function function;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();

  final _unameController = TextEditingController();
  final _pwordController = TextEditingController();

  @override
  void dispose() {
    _unameController.dispose();
    _pwordController.dispose();
    super.dispose();
  }

  void _handleSubmit(uname, pword) async {
    print(uname + pword);
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: uname, password: pword);
      widget.function(pword);
      UILibrary.reRoute(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormKey,
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _unameController,
                decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 10),
                        borderRadius: BorderRadius.circular(5))),
                onFieldSubmitted: (value) {
                  _handleSubmit(value, _pwordController.text);
                  _unameController.clear();
                  _pwordController.clear();
                },
              ),
              TextFormField(
                controller: _pwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueGrey, width: 10),
                        borderRadius: BorderRadius.circular(5))),
                onFieldSubmitted: (value) {
                  _handleSubmit(_unameController.text, value);
                  _unameController.clear();
                  _pwordController.clear();
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    print('submit button pressed');
                    _handleSubmit(_unameController.text, _pwordController.text);
                    _unameController.clear();
                    _pwordController.clear();
                  },
                  child: Text('Submit'))
            ],
          ),
        ));
  }
}
