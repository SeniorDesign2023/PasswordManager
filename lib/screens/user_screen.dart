import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserWidget());
  }
}

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String? emailaddress = '';

  Future<List> populateCards() async {
    var cards = [];
    var data = await db.collection(emailaddress.toString()).get();
    for (var docSnapshot in data.docs) {
      print('${docSnapshot.id} => ${docSnapshot.data()}');
      cards.add(Entry.fromFirestore(docSnapshot, null));
      print(cards);
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    emailaddress = user?.email;
    print(emailaddress);
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
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: '${currentEntry.pword}'));
                        },
                        child: Text('${currentEntry.name}'),
                      ));
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
    );
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
    print(data);
    return Entry(
      name: data?['name'],
      pword: data?['pword'],
    );
  }
}
