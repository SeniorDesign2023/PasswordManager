import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/UILibrary.dart';
//import 'package:app/screens/user_screen.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => Settings();
}

//settings screen
//Tyler O
class Settings extends State<UserSettingsScreen> {
  final db = FirebaseFirestore.instance;

  //used to change user email
  //Tyler O
  void changeCollectionName(String user, String newUser) async {
    var data = await db.collection(user.toString()).get();
    for (var docSnapshot in data.docs) {
      Map<String, dynamic> e={
        'name': docSnapshot.data()["name"],
        'pword': docSnapshot.data()["pword"]
      };
      db.collection(newUser.toString()).add(e);
    }
    deleteCollection(user);
    return;
  }

  //used to delete the current user account and used by: user_settings_screen:Settings.changeCollectionName(String, String)
  //Tyler O
  void deleteCollection(String user) async {
    var data = await db.collection(user.toString()).get();
    for (var docSnapshot in data.docs) {
      FirebaseFirestore.instance
        .collection(user.toString())
        .doc(docSnapshot.id).delete();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    UILibrary.secureArea(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Manager"),
        backgroundColor: ColourTheme.appBarBackground,
      ),
      drawer: UILibrary.drawer(context),
      body: Center(
        child: SizedBox(
          width: 1000,
          child: Expanded(
            child: ListView(
              children: <Widget>[
                //colour theme
                SizedBox(
                  width: 1000,
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        const Text("Dark theme"),
                        Switch(
                          value: ColourTheme.dark,
                          onChanged: (bool val) {
                            ColourTheme.changeTheme();
                          }
                        )
                      ]
                    )
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(),
                const SizedBox(height: 25),
                //change eamil
                TextButton(
                  child: const Text("Change Email"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        var emailCtrlr=TextEditingController();
                        return Center(
                          child: SizedBox(
                            width: 300,
                            height: 750,
                            child: AlertDialog(
                              title: const Text('Enter your new email'),
                              contentPadding: const EdgeInsets.all(10),
                              content: TextFormField(
                                controller: emailCtrlr,
                                decoration: const InputDecoration(hintText: 'Account name'),
                                onFieldSubmitted: (value) {
                                  String oldname=FirebaseAuth.instance.currentUser!.email!;
                                  if(emailCtrlr.text=='') {
                                    UILibrary.showError(context, 'Empty username!', "Please enter a username to save");
                                    return;
                                  }
                                  else if(!RegExp("[A-Za-z0-9_.]+@[A-Za-z0-9._]+\.[a-zA-Z0-9]+").hasMatch(emailCtrlr.text)) {
                                    UILibrary.showError(context, "User", "Please make sure to enter a real email");
                                    return;
                                  }
                                  try {
                                    FirebaseAuth.instance.currentUser!.updateEmail(emailCtrlr.text);
                                    changeCollectionName(oldname, emailCtrlr.text);
                                  } catch(e) {
                                    UILibrary.showError(context, "Error", "Unknown error occurred:\n$e");
                                  }
                                  emailCtrlr.clear();
                                  
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')
                                ),
                                TextButton(
                                  onPressed: () {
                                  if(emailCtrlr.text=='') {
                                    UILibrary.showError(context, 'Empty username!', "Please enter a username to save");
                                    return;
                                  }
                                  else if(!RegExp("[A-Za-z0-9_.]+@[A-Za-z0-9._]+\.[a-zA-Z0-9]+").hasMatch(emailCtrlr.text)) {
                                    UILibrary.showError(context, "User", "Please make sure to enter a real email");
                                    return;
                                  }
                                  try {
                                    FirebaseAuth.instance.currentUser!.updateEmail(emailCtrlr.text);
                                  } catch(e) {
                                    UILibrary.showError(context, "Error", "Unknown error occurred:\n$e");
                                  }
                                  emailCtrlr.clear();
                                },
                                  child: const Text('Submit')
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
                const SizedBox(height: 15),
                //change password
                TextButton(
                  child: const Text("Change Password"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        var pwd1Ctrlr=TextEditingController();
                        var pwd2Ctrlr=TextEditingController();
                        final _pwdChngKey=GlobalKey<FormState>();
                        return Center(
                          child: SizedBox(
                            width: 500,
                            child: Form(
                              key: _pwdChngKey,
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      controller: pwd1Ctrlr,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: 'Password',
                                          border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.blueGrey, width: 10),
                                          borderRadius: BorderRadius.circular(5)
                                        )
                                      ),
                                      onFieldSubmitted: (value) async {
                                        if (UILibrary.pwdValidation(pwd1Ctrlr.text, pwd2Ctrlr.text, context)) {
                                          try {
                                            final credential = await FirebaseAuth.instance.currentUser!.updatePassword(pwd1Ctrlr.text);
                                            //TODO: check if rest of passwords in collection need to be updated for seed change
                                            UILibrary.setseed(pwd1Ctrlr.text);
                                          } on FirebaseAuthException catch (e) {
                                            //print('Something went wrong');
                                            UILibrary.showError(context, "Error", "An unkown error occurred:\n$e");
                                          }
                                          pwd1Ctrlr.clear();
                                          pwd2Ctrlr.clear();
                                        }
                                      }
                                    ),
                                    TextFormField(
                                      controller: pwd1Ctrlr,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: 'Re-type password',
                                          border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.blueGrey, width: 10),
                                          borderRadius: BorderRadius.circular(5)
                                        )
                                      ),
                                      onFieldSubmitted: (value) async {
                                        if (UILibrary.pwdValidation(pwd1Ctrlr.text, pwd2Ctrlr.text, context)) {
                                          try {
                                            final credential = await FirebaseAuth.instance.currentUser!.updatePassword(pwd1Ctrlr.text);
                                            //TODO: check if rest of passwords in collection need to be updated for seed change
                                            UILibrary.setseed(pwd1Ctrlr.text);
                                          } on FirebaseAuthException catch (e) {
                                            //print('Something went wrong');
                                            UILibrary.showError(context, "Error", "An unkown error occurred:\n$e");
                                          }
                                          pwd1Ctrlr.clear();
                                          pwd2Ctrlr.clear();
                                        }
                                      }
                                    ),
                                    const SizedBox(height: 25), 
                                    TextButton(
                                      onPressed: () async {
                                        if (UILibrary.pwdValidation(pwd1Ctrlr.text, pwd2Ctrlr.text, context)) {
                                          try {
                                            final credential = await FirebaseAuth.instance.currentUser!.updatePassword(pwd1Ctrlr.text);
                                            //TODO: check if rest of passwords in collection need to be updated for seed change
                                            UILibrary.setseed(pwd1Ctrlr.text);
                                          } on FirebaseAuthException catch (e) {
                                            //print('Something went wrong');
                                            UILibrary.showError(context, "Error", "An unkown error occurred:\n$e");
                                          }
                                          pwd1Ctrlr.clear();
                                          pwd2Ctrlr.clear();
                                        }
                                      },
                                      child: const Text('Submit')
                                    )
                                  ],
                                ),
                              )
                            )
                          )
                        );
                      },
                    );
                  }
                ),
                const SizedBox(height: 25),
                const Divider(),
                const SizedBox(height: 25),
                //delete account
                TextButton(
                  child: const Text("Delete account", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Center(
                          child: SizedBox(
                            width: 500,
                            height: 600,
                            child: AlertDialog(
                              title: const Text("Delete Account?"),
                              content: const Text("Are you sure you want to delete your account?"),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Delete'),
                                  onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return Center(
                                        child: SizedBox(
                                          width: 500,
                                          height: 600,
                                          child: AlertDialog(
                                            title: const Text("Delete Account?"),
                                            content: const Text("You will be unable to get your passwords ever again."),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                                ),
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  deleteCollection(FirebaseAuth.instance.currentUser!.email.toString());
                                                  FirebaseAuth.instance.currentUser!.delete();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  //firebase oauth logout
                                                  try {
                                                  FirebaseAuth.instance.signOut();
                                                  FirebaseAuth.instance.signOut();
                                                  } catch(e) {}
                                                  //go to the landing screen
                                                  Navigator.pushReplacementNamed(context, '/');
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                                ),
                                                child: const Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ]
                                          )
                                        )
                                      );
                                    },
                                  );
                                  },
                                ),
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
                )
              ]
            )
          )
        )
      )
    );
  }
}