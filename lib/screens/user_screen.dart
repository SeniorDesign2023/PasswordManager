import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    final userlist = db.collection("users").doc(user?.email);
    userlist.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
    });
    return Scaffold(
      body: Column(
        children: ListView.builder(itemBuilder: ((context, index) {
          return Container(
            child: Card(
              child: InkWell(splashColor: Colors.blue,),
            ),
          )
        })),
        ),
      ),
    );
  }
}

class Entry {
  const Entry(
    {required this.name,
    required this.pword}
  );

  factory Entry.fromDB(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final pword = data['pword'] as String;

    return Entry(name: name, pword: pword);
  }

  final String name;
  final String pword;
}