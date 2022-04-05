import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/navbar.dart';
import 'package:todo_app/appbar.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/screens/home.dart';
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Completed extends StatefulWidget {
  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  var selected = false;
  User user = FirebaseAuth.instance.currentUser;
  Widget _buildList(QuerySnapshot snapshot) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.brown[50],
          image: DecorationImage(image: AssetImage('Assets/images/Logo.png'))),
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          return Card(
            elevation: 5,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Slidable(
                actionExtentRatio: 0.2,
                key: ValueKey(doc.id),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    margin: EdgeInsets.all(8),
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${doc['name'].toString()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${DateFormat("yMMMMEEEEd").format(doc['DOC'].toDate())}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                actionPane: SlidableDrawerActionPane(),
                actions: [
                  GestureDetector(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(user.email)
                          .doc(doc.id)
                          .delete();
                      final snackBar = SnackBar(
                        content: const Text('Entry has been deleted'),
                        action: SnackBarAction(
                          label: 'undo',
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection(user.email)
                                .add({
                              'name': doc['name'],
                              'description': doc['description'],
                              'completed': true,
                              'DOC': doc['DOC'],
                              'created': doc['created']
                            });
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                        height: 70,
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  var detailedView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom('Completed'),
        preferredSize: Size(double.infinity, 50),
      ),
      // AppBar(
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Provider.of<UserProvider>(context, listen: false).signOut();
      //           Navigator.pop(context);
      //         },
      //         icon: Icon(Icons.logout))
      //   ],
      // ),
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.92,
          color: Colors.brown[50],
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text('No completed tasks yet'),
                      ),
                    );
                  return _buildList(snapshot.data);
                },
                stream: FirebaseFirestore.instance
                    .collection(user.email)
                    .where('completed', isEqualTo: true)
                    .snapshots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
