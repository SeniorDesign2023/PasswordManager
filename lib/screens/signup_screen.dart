import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  bool _passwordValidation(pword, pword2) {
    if (pword == pword2) {
      return true;
    } else {
      return false;
    }
  }

  void _handleSubmit(uname, pword, pword2) async {
    if (_passwordValidation(pword, pword2)) {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: uname, password: pword);
        reRoute();
      } on FirebaseAuthException catch (e) {
        print('Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _signupFormKey,
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
                  _handleSubmit(value, _pwordController.text,
                      _pwordConfirmationController.text);
                  dispose();
                },
              ),
              TextFormField(
                  controller: _pwordController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 10),
                          borderRadius: BorderRadius.circular(5))),
                  onFieldSubmitted: (value) {
                    _handleSubmit(_unameController.text, value,
                        _pwordConfirmationController.text);
                    dispose();
                  }),
              TextFormField(
                  controller: _pwordConfirmationController,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey, width: 10),
                          borderRadius: BorderRadius.circular(5))),
                  onFieldSubmitted: (value) {
                    _handleSubmit(
                        _unameController.text, _pwordController.text, value);
                    dispose();
                  }),
              ElevatedButton(
                  onPressed: () => _handleSubmit(_unameController.text,
                      _pwordController.text, _pwordConfirmationController.text),
                  child: Text('Submit'))
            ],
          ),
        ));
  }
}
