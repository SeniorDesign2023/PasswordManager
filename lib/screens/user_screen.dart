import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as spicy_salsa;
import 'package:app/UILibrary.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key, required this.function});

  Function function;

  @override
  Widget build(BuildContext context) {
    UILibrary.secureArea(context);
    return Scaffold(
      body: UserWidget(
        function: function,
      )
    );
  }
}

class UserWidget extends StatefulWidget {
  UserWidget({super.key, required this.function});

  Function function;

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String seed = '';
  String? emailaddress = '';
  late FutureBuilder updatableList;
  bool refreshed=false;

  Future<List> populateCards() async {
    var cards = [];
    var data = await db.collection(emailaddress.toString()).get();
    for (var docSnapshot in data.docs) {
      var e=Entry(
        id: docSnapshot.id,
        name: docSnapshot.data()["name"],
        pword: docSnapshot.data()["pword"]
      );
      cards.add(e);
    }
    return cards;
  }

  Future<void> addEntry(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
      .collection(emailaddress.toString())
      .add(data);
  }

  Future<void> _updateEntry(BuildContext context, String pwd, Entry oldData) async {
    Map<String, dynamic> saveData = {
      'name': oldData.name,
      'pword': pwd
    };
    FirebaseFirestore.instance
      .collection(emailaddress.toString())
      .doc(oldData.id).update(saveData);
    setState(() {
      refreshed=false;
    });
  }

  Future<void> _deleteEntry(Entry e) async {
    FirebaseFirestore.instance
      .collection(emailaddress.toString())
      .doc(e.id).delete();
    setState(() {
      refreshed=false;
    });
  }

  //Menu for confirming a deletion of an entry
  //Tyler O
  void _deleteItem(BuildContext context, String seed, Entry currentEntry) {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Container(
            width: 500,
            height: 750,
            child: AlertDialog(
              title: const Text("Delete a Password?"),
              content: Text(
                "Are you sure you want to delete the following?\n"
                "Username: ${currentEntry.name}\n"
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    //Delete item
                    _deleteEntry(currentEntry);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10), 
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    //update content
                    Navigator.of(context).pop();
                    _modifyEntryMenu(context, seed, currentEntry);
                  },
                ),
              ],
            )
          )
        );
      },
    );
  }

  //Menu for modifying or deleting and entry card
  //Tyler O
  void _modifyEntryMenu(BuildContext context, String seed, Entry currentEntry) {
    String pwd=currentEntry.pword!;
    showDialog(
      context: context,
      builder: (_) {
        var pwdCtrlr=TextEditingController();
        pwdCtrlr.text=currentEntry.pword!;
        //TODO: ENCRYPT
        //pwdCtrlr.text=salsaDecrypt(currentEntry.pword!, seed);//currentEntry.pword!;
        return Center(
          child: Container(
            width: 850,
            height: 400,
            child: AlertDialog(
              title: Text("Modify ${currentEntry.name}"),
              content: Form(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //password to modify
                      TextFormField(
                        controller: pwdCtrlr,
                        //obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderSide:
                              const BorderSide(color: Colors.blueGrey, width: 10),
                              borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        onFieldSubmitted: (value) {
                          pwd=pwdCtrlr.text; //TODO: ENCRYPT
                          _updateEntry(context, pwd, currentEntry);
                          pwdCtrlr.clear();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                )
              ),
              //buttons
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    alignment: Alignment.centerLeft
                  ),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteItem(context, seed, currentEntry);
                  },
                ),
                const SizedBox(width: 75), 
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Done'),
                  onPressed: () {
                    //update content
                    _updateEntry(context, pwdCtrlr.text, currentEntry);
                    pwdCtrlr.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          )
        );
      },
    );
  }

  FutureBuilder updateCardList() {
    setState(() {
      updatableList=FutureBuilder(
        future: populateCards(),
        builder: (BuildContext bldrCntxt, snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (itmBldrCntxt, index) {
                var currentEntry = snapshot.data?.elementAt(index);
                return Card(
                  child: InkWell(
                    splashColor: Colors.blue,
                    onTap: () async {
                      //print(salsaDecrypt(currentEntry.pword, seed));
                      //TODO: ENCRYPT
                      Clipboard.setData(ClipboardData(
                          text: currentEntry.pword)); /*salsaDecrypt(
                              currentEntry.pword, seed)));*/
                    },
                    child: SizedBox(
                      width: 200,
                      height: 75,
                      child: ListTile(
                        title: Center(child: Text('${currentEntry.name}')),
                        trailing: IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Modify',
                          onPressed: () {
                            _modifyEntryMenu(context, seed, currentEntry);
                          },
                        )
                      )
                    )
                  )
                );
              }
            );
          }
          else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Loading...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        }
      );
      refreshed=true;
    });
    return updatableList;
  }

  @override
  Widget build(BuildContext context) {
    seed = widget.function();
    emailaddress = user?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Manager"),
        backgroundColor: ColourTheme.appBarBackground,
      ),
      drawer: UILibrary.drawer(context),
      body: Center(
        child: SizedBox(
          width: 1000,
          child: (refreshed)?updatableList:updateCardList()
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              var nameController = TextEditingController();
              var pwordController = TextEditingController();
              return Center(
                child: Container(
                  width: 300,
                  height: 750,
                  child: AlertDialog(
                    title: const Text('Enter a new password'),
                    contentPadding: const EdgeInsets.all(10),
                    content: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(hintText: 'Account name'),
                          onFieldSubmitted: (value) {
                            Map<String, dynamic> saveData = {
                              'name': nameController.text,
                              'pword': pwordController.text
                                  //TODO: ENCRYPT
                                  //salsaEncrypt(pwordController.text, seed)
                            };
                            nameController.clear();
                            pwordController.clear();
                            addEntry(saveData);
                            setState(() {
                              updatableList=updateCardList();
                            });
                          },
                        ),
                        TextFormField(
                          controller: pwordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: 'Password'),
                          onFieldSubmitted: (value) {
                            Map<String, dynamic> saveData = {
                              'name': nameController.text,
                              'pword': pwordController.text
                                  //TODO: ENCRYPT
                                  //salsaEncrypt(pwordController.text, seed)
                            };
                            nameController.clear();
                            pwordController.clear();
                            addEntry(saveData);
                            setState(() {
                              updatableList=updateCardList();
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> saveData = {
                              'name': nameController.text,
                              'pword': pwordController.text
                                  //TODO: ENCRYPT
                                  //salsaEncrypt(pwordController.text, seed)
                            };
                            nameController.clear();
                            pwordController.clear();
                            addEntry(saveData);
                            setState(() {
                              updatableList=updateCardList();
                            });
                          },
                          child: const Text('Submit'))
                    ],
                  ),
                ),
              );
            }
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      )
    );
  }
}

class Entry {
  final String? name;
  final String? pword;
  final String? id;

  Entry({this.name, this.pword, this.id});

  factory Entry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Entry(
      name: data?['name'],
      pword: data?['pword'],
    );
  }
}

String salsaEncrypt(String text, String seed) {
  final key = spicy_salsa.Key.fromUtf8(seed);
  final iv = spicy_salsa.IV.fromLength(8);
  final encrypter = spicy_salsa.Encrypter(spicy_salsa.Salsa20(key));

  return encrypter.encrypt(text, iv: iv).base64;
}

String salsaDecrypt(String text, String seed) {
  final key = spicy_salsa.Key.fromUtf8(seed);
  final iv = spicy_salsa.IV.fromLength(8);
  final decrypter = spicy_salsa.Encrypter(spicy_salsa.Salsa20(key));

  return decrypter
      .decrypt(spicy_salsa.Encrypted.from64(text), iv: iv)
      .toString();
}
