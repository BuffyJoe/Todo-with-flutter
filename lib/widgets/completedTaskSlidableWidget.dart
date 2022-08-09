import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CompletedTaskSlidableWidget extends StatelessWidget {
  final QuerySnapshot snapshot;
  final bool detailedView;
  CompletedTaskSlidableWidget(this.snapshot, this.detailedView);
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Brightness theme = Theme.of(context).brightness;
    return Container(
      decoration: BoxDecoration(
          // color: Colors.brown[50],
          image: DecorationImage(image: AssetImage('Assets/images/Logo.png'))),
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          // final time = DateFormat('MM/dd/yy').parse(doc['time']);
          // print(time);
          return Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 3),
            height: detailedView ? 170 : 70,
            decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
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
                        '${doc['name'].toString()} (completed)',
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
                subtitle: detailedView
                    ? Container(
                        height: 90,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 0, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
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
                                    content:
                                        const Text('Entry has been deleted'),
                                    action: SnackBarAction(
                                      label: 'undo',
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .add({
                                          'name': doc['name'],
                                          'id': user.email,
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
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        // bottomRight: Radius.circular(20),
                      ),
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
        },
      ),
    );
  }
}
