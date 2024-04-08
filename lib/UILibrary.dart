//Used for reused UI items

//flutter visual design imports
import 'package:flutter/material.dart';
import 'package:app/main.dart';

class UILibrary {

  //routing back to the main page
  static void reRoute(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/user',
    );
  }

  //Landing bar
  //Tyler O
  //Used for the sign in/up pages, to navigate to the main landing page
  static AppBar userAuthPageBar(BuildContext context) {
    return AppBar(
      title: const Text("Password Manager"),
      leading: IconButton(
        onPressed: (){
          Navigator.pushNamed(context, '/');
        },
        icon: const Icon(Icons.arrow_back),
      )
    );
  }

  //Landing bar
  //Tyler O
  //Used for the landing page, to navigate between logging in and creating a new user
  static AppBar landingPageAuthPageBar(BuildContext context) {
    return AppBar(
      title: const Text("Password Manager"),
      backgroundColor: ColourTheme.appBarBackground,
    );
  }

  //Menu Drawer
  //Tyler O
  //Used for when the user is already logged, and as a navigational piece
  static Drawer menuDrawer(BuildContext context) {
    return Drawer(
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListView (
            children: <Widget>[
              const Text(""),
              const Divider(
                color: Colors.blue
              ),
              ListTile(
                title: const Text("Main Menu"),
                leading: const Icon(Icons.home, color: Colors.black),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                }
              ),
              ListTile(
                title: const Text('Make new short URL'),
                leading: const Icon(Icons.control_point_rounded, color: Colors.black),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeUrl(c: context)));
                }
              ),
              ListTile(
                title: const Text('Goto URL'),
                leading: const Icon(Icons.open_in_new, color: Colors.black),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>GotoUrl()));
                }
              ),
              ListTile(
                title: const Text('State Example'),
                leading: const Icon(Icons.help, color: Colors.black),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Example()));
                }
              ),
              const Divider(
                color: Colors.blue
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout, color: Colors.black),

              )
            ]
          )
        )
    );
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
  