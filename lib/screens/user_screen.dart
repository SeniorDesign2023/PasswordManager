import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as spicy_salsa;

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

  Future<List> populateCards() async {
    var cards = [];
    var data = await db.collection(emailaddress.toString()).get();
    for (var docSnapshot in data.docs) {
      cards.add(Entry.fromFirestore(docSnapshot, null));
    }
    return cards;
  }

  Future<void> addEntry(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(emailaddress.toString())
        .add(data);
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
                        return Card(
                            child: InkWell(
                                splashColor: Colors.blue,
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: salsaDecrypt(
                                          currentEntry.pword, seed)));
                                },
                                child: SizedBox(
                                  width: 400,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('${currentEntry.name}')],
                                  ),
                                )));
                      })
                ];
              } else if (snapshot.hasError) {
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
            }),
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
                        title: Text('Enter a new password'),
                        contentPadding: EdgeInsets.all(10),
                        content: ListView(
                          shrinkWrap: true,
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(hintText: 'Account name'),
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
                              decoration: InputDecoration(hintText: 'Password'),
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
                              child: Text('Cancel')),
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
                              child: Text('Submit'))
                        ],
                      ),
                    ),
                  );
                });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ));
  }
}

class Entry {
  final String? name;
  final String? pword;

  Entry({this.name, this.pword});

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
