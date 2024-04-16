//Used for reused UI items

//flutter visual design imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/main.dart';
import 'package:app/screens/landing_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/signup_screen.dart';
import 'package:app/screens/user_screen.dart';
import 'package:app/screens/user_settings_screen.dart';

//dart imports for crypto
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UILibrary {
  //used to make sure user is logged in
  //Tyler O
  static void secureArea(BuildContext context) {
    if(FirebaseAuth.instance.currentUser==null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  //used to create error messages, or info pop ups
  //Tyler O
  static void showError(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: 500,
            height: 600,
            child: AlertDialog(
              title: Text(title),
              content: Text(msg),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]
            )
          )
        );
      },
    );
  }

  static String _seed = '';

  //used to set/get the seed as an md5 hash of the string input
  //Matt
  static void setseed(string) {
    _seed = md5.convert(utf8.encode(string)).toString();
    //print(_seed);
  }

  //getseed
  //Matt bar
  //used to get the seed as a public accessor
  static String getseed() => _seed;

  //routes
  //Matt
  //Modified by Tyler
  //used for all the routes used in the app
  static final Map<String, Widget Function(BuildContext)> routes={
    '/': (context) => const LandingScreen(),
    '/login': (context) => LoginScreen(function: setseed),
    '/signup': (context) => SignUpScreen(function: setseed),
    '/user': (context) => UserScreen(function: getseed),
    '/user/settings': (context) => const UserSettingsScreen(),
  };

  //routing back to the main user page
  //Tyler O
  static void reRoute(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/user');
  }

  //drawer
  //Tyler O
  //used for routing and navigation once user is logged in
  static Drawer drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Password manager!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Passwords'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/user');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/user/settings');
                  },
                )
              ]
            )
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  const Divider(
                    color: Colors.blue
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    leading: const Icon(Icons.logout, color: Colors.black),
                    onTap: () {
                      //firebase oauth logout
                      FirebaseAuth.instance.signOut();
                      FirebaseAuth.instance.signOut();
                      //go to the landing screen
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }

  //Landing bar
  //Tyler O
  //Used for the sign in/up pages, to navigate to the main landing page
  static AppBar userAuthPageBar(BuildContext context, String name) {
    return AppBar(
      title: Center(
        child: Text(name)
      ),
/*      leading: IconButton(
        onPressed: (){
          Navigator.pushReplacementNamed(context, '/');
        },
        icon: const Icon(Icons.arrow_back),
      )*/
    );
  }
  
  //used for checking passwords are the same
  //Tyler O
  static bool pwdValidation(pword, pword2, context) {
    if((pword=="")||(pword2=="")) {
      UILibrary.showError(context, "Missing", "Please fill the sign up for completely");
      return false;
    }
    else if((pword.length<6)||(pword2.length<6)) {
      UILibrary.showError(context, "Password length", "Please make sure you have atleast 6 characters in your password");
      return false;
    }
    else if(pword==pword2) {
      return true;
    }
    else {
      UILibrary.showError(context, "Password match", "Please make sure passwords match");
      return false;
    }
  }
}

//Color themes
//Tyler O
//used for color schemes across the app
class ColourTheme {
  static bool dark=true;
  static Color loading=Colors.grey.shade600;
  static Color appBarBackground=Colors.blueGrey.shade800;
  static ThemeData theme=ThemeData.dark();
  static MainAppState? main;

  ColourTheme(MainAppState mainApp) {
    main=mainApp;
  }

  static changeTheme() {
    main!.changeTheme();
  }

  static updateTheme() {
    if(dark) {
      loading=Colors.grey.shade600;
      appBarBackground=Colors.blueGrey.shade800;
      theme=ThemeData.dark();
      dark=!dark;
    }
    else {
      theme=ThemeData.light();
      appBarBackground=Colors.blue.shade300;
      loading=Colors.blue.shade100;
      dark=!dark;
    }
  }
}
  