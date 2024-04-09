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
    return Scaffold(
        body: UserWidget(
      function: function,
    ));
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

  //used for the form asking to modify an entry
  final _unameController = TextEditingController();
  final _pwordController = TextEditingController();

  //used for modifying entries
  void _handleModifySubmit(uname, pword) async {
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

  Future<List> populateCards() async {
    var cards = [];
    var data = await db.collection(emailaddress.toString()).get();
    for (var docSnapshot in data.docs) {
      //print(docSnapshot.id);
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
  Future<void> _updateEntry(BuildContext context, Map<String, dynamic> saveData, Entry oldData) async {
    FirebaseFirestore.instance
      .collection(emailaddress.toString())
      .doc(oldData.id).update(saveData);
  }
  Future<void> _deleteEntry(Entry e) async {
    FirebaseFirestore.instance
      .collection(emailaddress.toString())
      .doc(e.id).delete();
  }

  static Future<ClipboardData?> getClipBoardData() async {
    final Map<String, dynamic>? result=await SystemChannels.platform.invokeMethod(
      'Clipboard.getData',
      Clipboard.kTextPlain,
    );
    if(result==null) {
      return null;
    }
    return ClipboardData(text: result['text'] as String);
  }

  //Menu for confirming a deletion of an entry
  //Tyler O
  void _deleteItem(BuildContext context, Entry currentEntry) {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Container(
            width: 300,
            height: 750,
            child: AlertDialog(
              title: Text("Delete ${currentEntry.name}"),
              content: Text(
                "Are you sure you want to delete the following?\n"
                "Username: ${currentEntry.name}\n"
                "Password: ${currentEntry.pword}\n"
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Delete'),
                  onPressed: () {
                    //Delete item
                    _deleteEntry(currentEntry);
                    Navigator.of(context).pop();
                  },
                ),
                const Text('\t'), 
                //TextButton(onPressed: () {}, child: const Text('    ')),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    //update content
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

  //Menu for modifying or deleting and entry card
  //Tyler O
  void _modifyEntryMenu(BuildContext context, String seed, var currentEntry) {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Container(
            width: 300,
            height: 750,
            child: AlertDialog(
              title: Text("Modify ${currentEntry.name}"),
              //content entries
              content: Form(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //username to modify
                      TextFormField(
                        initialValue: currentEntry.name,
                        controller: _unameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderSide:
                              const BorderSide(color: Colors.blueGrey, width: 10),
                              borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        onFieldSubmitted: (value) {
                          Map<String, dynamic> saveData = {
                            'name': _unameController.text,
                            'pword':
                                salsaEncrypt(_pwordController.text, seed)
                          };
                          _updateEntry(context, saveData, currentEntry);
                          _unameController.clear();
                          _pwordController.clear();
                        },
                      ),
                      //password to modify
                      TextFormField(
                        //initialValue: salsaDecrypt(currentEntry.pword, seed),
                        initialValue: "test",
                        controller: _pwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderSide:
                              const BorderSide(color: Colors.blueGrey, width: 10),
                              borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        onFieldSubmitted: (value) {
                          Map<String, dynamic> saveData = {
                            'name': _unameController.text,
                            'pword':
                                salsaEncrypt(_pwordController.text, seed)
                          };
                          _updateEntry(context, saveData, currentEntry);
                          _unameController.clear();
                          _pwordController.clear();
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
                  ),
                  child: const Text('Delete'),
                  onPressed: () {
                    _deleteItem(context, currentEntry);
                    Navigator.of(context).pop();
                  },
                ),
                const Text('\t'), 
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Done'),
                  onPressed: () {
                    //update content
                    Map<String, dynamic> saveData = {
                      'name': _unameController.text,
                      'pword':
                          salsaEncrypt(_pwordController.text, seed)
                    };
                    _updateEntry(context, saveData, currentEntry);
                    _unameController.clear();
                    _pwordController.clear();
                  },
                ),
              ],
            )
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    seed = widget.function();
    emailaddress = user?.email;
    var cardlist = populateCards();
    return Scaffold(
      body: FutureBuilder(
        future: cardlist,
        builder: (BuildContext context, snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var currentEntry = snapshot.data?.elementAt(index);
                  ClipboardData? clipboardVal;
                  return Card(
                    child: InkWell(
                      splashColor: Colors.blue,
                      onTap: () async {
                        //grab previous clipboard value for long pressed use
                        clipboardVal=await getClipBoardData();
                        //print(salsaDecrypt(currentEntry.pword, seed));
                        Clipboard.setData(const ClipboardData(
                            text: "test")); /*salsaDecrypt(
                                currentEntry.pword, seed)));*/
                      },/*
                      onLongPress: () {
                        //modifying entry data, put what was in clipboard back
                        Clipboard.setData(clipboardVal!);
                        //create menu for modifying the data in that card
                        _modifyEntryMenu(context, seed, currentEntry);

                      },*/
                      child: SizedBox(
                        width: 400,
                        height: 150,
                        child: /*Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${currentEntry.name}')
                          ],
                        ),*/
                        ListTile(
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
              )
            ];
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
                          decoration:
                              const InputDecoration(hintText: 'Account name'),
                          onFieldSubmitted: (value) {
                            Map<String, dynamic> saveData = {
                              'name': nameController.text,
                              'pword':
                                  salsaEncrypt(pwordController.text, seed)
                            };
                            nameController.clear();
                            pwordController.clear();
                            addEntry(saveData);
                            cardlist = populateCards();
                          },
                        ),
                        TextFormField(
                          controller: pwordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: 'Password'),
                          onFieldSubmitted: (value) {
                            Map<String, dynamic> saveData = {
                              'name': nameController.text,
                              'pword':
                                  salsaEncrypt(pwordController.text, seed)
                            };
                            nameController.clear();
                            pwordController.clear();
                            addEntry(saveData);
                            cardlist = populateCards();
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
                              'pword':
                                  salsaEncrypt(pwordController.text, seed)
                            };
                            nameController.clear();
                            pwordController.clear();
                            addEntry(saveData);
                            cardlist = populateCards();
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
