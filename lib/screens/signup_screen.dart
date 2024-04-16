import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/UILibrary.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key, required this.function}) : super(key: key);

  Function function;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UILibrary.userAuthPageBar(context, "Password Manager Sign Up"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SignUpForm(function: function)],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  SignUpForm({super.key, required this.function});

  Function function;

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _signupFormKey = GlobalKey<FormState>();

  final _unameController = TextEditingController();
  final _pwordController = TextEditingController();
  final _pwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    _unameController.dispose();
    _pwordController.dispose();
    _pwordConfirmationController.dispose();
    super.dispose();
  }

  void reRoute() {
    Navigator.pushNamed(context, '/user');
  }

  //Matt
  //Modified by Tyler (for UI)
  void _handleSubmit(uname, pword, pword2) async {
    if (UILibrary.pwdValidation(pword, pword2, context)) {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: uname, password: pword);
        widget.function(pword);
        Navigator.pushReplacementNamed(context, '/user');
      } on FirebaseAuthException catch (e) {
        if((uname=='')||(pword=='')||(pword2=='')) {
          UILibrary.showError(context, "Missing", "Please fill the sign up for completely");
        }
        else if(pword.length<6) {
          UILibrary.showError(context, "Password length", "Please make sure you have atleast 6 characters in your password");
        }
        else if(!RegExp("[A-Za-z0-9_.]+@[A-Za-z0-9._]+\.[a-zA-Z0-9]+").hasMatch(uname)) {
          UILibrary.showError(context, "User", "Please make sure to enter a real email");
        }
        else {
        //print('Something went wrong');
          UILibrary.showError(context, "Error", "An unkown error occurred:\n$e");
        }
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
          key: _signupFormKey,
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
                      borderSide:const BorderSide(color: Colors.blueGrey, width: 10),
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  onFieldSubmitted: (value) {
                    _handleSubmit(value, _pwordController.text, _pwordConfirmationController.text);
                    _pwordConfirmationController.clear();
                    _pwordController.clear();
                    _unameController.clear();
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
                    _handleSubmit(_unameController.text, value, _pwordConfirmationController.text);
                    _pwordConfirmationController.clear();
                    _pwordController.clear();
                    _unameController.clear();
                  }
                ),
                const SizedBox(height: 15), 
                TextFormField(
                  controller: _pwordConfirmationController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey, width: 10),
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                  onFieldSubmitted: (value) {
                    _handleSubmit(
                        _unameController.text, _pwordController.text, value);
                    _pwordConfirmationController.clear();
                    _pwordController.clear();
                    _unameController.clear();
                  }
                ),
                const SizedBox(height: 25), 
                ElevatedButton(
                    onPressed: () => _handleSubmit(_unameController.text,
                        _pwordController.text, _pwordConfirmationController.text),
                    child: const Text('Submit'))
              ],
            ),
          )
        )
      )
    );
  }
}
