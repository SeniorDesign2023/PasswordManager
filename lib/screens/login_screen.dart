import 'package:app/UILibrary.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, required this.function}) : super(key: key);

  Function function;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UILibrary.userAuthPageBar(context, "Password Manager Login"),
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

  //Matt
  //Modified by Tyler (for UI)
  void _handleSubmit(uname, pword) async {
    //print(uname + pword);
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: uname, password: pword);
      widget.function(pword);
      Navigator.pushReplacementNamed(context, '/user',);
    } on FirebaseAuthException catch (e) {
      if((uname=='')||(pword=='')) {
        UILibrary.showError(context, "Missing", "Please fill both username and password out");
      }
      else if (e.code == 'user-not-found') {
        UILibrary.showError(context, "Not found!", "That username was not found");
        //print('No user found for that email.');
      }
      else if (e.code == 'wrong-password') {
        UILibrary.showError(context, "Password", "Wrong password! Try again.");
        //print('Wrong password provided for that user.');
      }
      else if(RegExp("").hasMatch(uname)) {
        UILibrary.showError(context, "Not found!", "That username was not found");
      }
      else {
        UILibrary.showError(context, "Error", "An unknown error occurred:\n$e");
      }
    }
  }

  //Matt
  //Modified by Tyler (for UI)
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        child: Form(
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _unameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey, width: 10),
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                  onFieldSubmitted: (value) {
                    _handleSubmit(value, _pwordController.text);
                    _unameController.clear();
                    _pwordController.clear();
                  },
                ),
                const SizedBox(height: 15), 
                TextFormField(
                  controller: _pwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueGrey, width: 10),
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  onFieldSubmitted: (value) {
                    _handleSubmit(_unameController.text, value);
                    _unameController.clear();
                    _pwordController.clear();
                  },
                ),
                const SizedBox(height: 25), 
                ElevatedButton(
                  onPressed: () {
                    //print('submit button pressed');
                    _handleSubmit(_unameController.text, _pwordController.text);
                    _unameController.clear();
                    _pwordController.clear();
                  },
                  child: const Text('Submit')
                )
              ],
            ),
          )
        )
      )
    );
  }
}
