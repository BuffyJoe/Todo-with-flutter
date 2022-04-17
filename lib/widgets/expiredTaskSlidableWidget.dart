import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ExpiredTaskSlidableWidget extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  ExpiredTaskSlidableWidget(this.doc);
  DateTime today = DateTime.now();
  int backPressCounter = 1;
  int backPressTotal = 2;
  var detailedView = false;

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionExtentRatio: 0.2,
      key: ValueKey(doc.id),
      child: ListTile(
        title: Container(
          margin: EdgeInsets.all(8),
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${doc['name'].toString()} (expired)',
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
              Text(
                doc['time'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        subtitle: detailedView
            ? Container(
                height: 90,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 15, left: 0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description: ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${doc['description']}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              )
            : Container(),
      ),
      actionPane: SlidableDrawerActionPane(),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    backgroundColor: Colors.brown[50],
                    content: Text('Delete \" ${doc['name']} \"?'),
                    actions: [
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        color: Colors.red,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(user.email)
                              .doc(doc.id)
                              .delete();
                          Navigator.pop(context);
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
                                  'completed': false,
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
                      ),
                    ],
                  );
                });
          },
          child: Container(
            height: detailedView ? 170 : 70,
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: detailedView ? 50 : 30,
            ),
          ),
        ),
      ],
    );
  }
}
