import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/screens/edit.dart';

class ActiveTaskSlidableWidget extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final bool detailedView;
  ActiveTaskSlidableWidget(this.doc, this.detailedView);
  DateTime today = DateTime.now();
  int backPressCounter = 1;
  int backPressTotal = 2;

  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,

      // clipBehavior: Clip.hardEdge,
      // padding: EdgeInsets.all(),
      child: Slidable(
        actionExtentRatio: 1 / 3,
        key: ValueKey(doc.id),
        child: ListTile(
          title: Container(
            margin: EdgeInsets.all(8),
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                doc['expired']
                    ? Text(
                        '${doc['name'].toString()} (expired)',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      )
                    : Text(
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
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
              FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(doc.id)
                  .update({'completed': true});
              final snackBar = SnackBar(
                content: const Text('task has been completed'),
                action: SnackBarAction(
                  label: 'undo',
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(doc.id)
                        .update({'completed': false});
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Container(
              height: detailedView ? 170 : 70,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                    size: detailedView ? 50 : 30,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) {
                return Edit(
                    task: doc.id.toString(),
                    name: doc['name'],
                    description: doc['description'],
                    completed: doc['completed'],
                    doc: doc['DOC'],
                    expired: doc['expired']);
              }));
            },
            child: Container(
              height: detailedView ? 170 : 70,
              color: Colors.grey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: detailedView ? 50 : 30,
                    ),
                  ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      content: Text('Delete \" ${doc['name']} \"?'),
                      actions: [
                        FlatButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: const Text('Yes'),
                          color: Colors.red,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(doc.id)
                                .delete();
                            Navigator.pop(context);
                            final snackBar = SnackBar(
                              content: const Text('Entry has been deleted'),
                              action: SnackBarAction(
                                label: 'undo',
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .add({
                                    'name': doc['name'],
                                    'description': doc['description'],
                                    'completed': false,
                                    'DOC': doc['DOC'],
                                    'id': user.email,
                                    'created': doc['created'],
                                    'time': doc['time'],
                                    'expired': doc['expired']
                                  });
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Container(
              height: detailedView ? 170 : 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.red,
              ),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: detailedView ? 50 : 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
