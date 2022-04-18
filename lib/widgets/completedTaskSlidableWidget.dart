import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CompletedTaskSlidableWidget extends StatelessWidget {
  final QuerySnapshot snapshot;
  CompletedTaskSlidableWidget(this.snapshot);
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.brown[50],
          image: DecorationImage(image: AssetImage('Assets/images/Logo.png'))),
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          // final time = DateFormat('MM/dd/yy').parse(doc['time']);
          // print(time);
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
                              'created': doc['created'],
                              'time': doc['time'],
                              'expired': doc['expired']
                            });
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                        height: 70,
                        color: Colors.red,
                        child: const Icon(
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
}
