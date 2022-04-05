import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/login.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/navbar.dart';
import 'package:todo_app/screens/edit.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/appbar.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // create task function
  @override
  User user = FirebaseAuth.instance.currentUser;

  // ask before exiting the app
  int backPressCounter = 1;
  int backPressTotal = 2;
  Future<bool> onWillPop() {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.brown[50],
            content: Text('Exit App?'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);

                  return Future.value(false);
                },
              ),
              FlatButton(
                  child: Text('Yes'),
                  color: Colors.red,
                  onPressed: () {
                    SystemNavigator.pop();
                    return Future.value(true);
                  }),
            ],
          );
        });
  }

  var counter = '';

  var selected = false;
  Widget _buildList(QuerySnapshot snapshot) {
    return Container(
      child: ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          return Card(
            color: Colors.black54,
            elevation: 5,
            child: Container(
              padding: EdgeInsets.zero,
              height: detailedView ? 170 : 70,
              color: Colors.blue,
              child: Slidable(
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
                      FirebaseFirestore.instance
                          .collection(user.email)
                          .doc(doc.id)
                          .update({
                        'completed': true,
                      });
                      final snackBar = SnackBar(
                        content: const Text('task has been completed'),
                        action: SnackBarAction(
                          label: 'undo',
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection(user.email)
                                .doc(doc.id)
                                .update({'completed': false});
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      height: detailedView ? 170 : 70,
                      color: Colors.green,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: detailedView ? 50 : 30,
                            ),
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return Edit(
                            task: doc.id.toString(),
                            name: doc['name'],
                            description: doc['description'],
                            completed: doc['completed'],
                            doc: doc['DOC']);
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
                                      content:
                                          const Text('Entry has been deleted'),
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
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: detailedView ? 50 : 30,
                      ),
                    ),
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
  final _taskController = TextEditingController();

  final _description = TextEditingController();
  List items = ['sign up', 'setting', 'about us'];

  @override
  Widget build(BuildContext context) {
    void onSelected(int value) {
      switch (value) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (builder) {
            return Home();
          }));
          break;
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (builder) {
            return Completed();
          }));
          break;
      }
    }

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(
          home: true,
        ),
        appBar: PreferredSize(
          child: AppBarCustom(user.email),
          preferredSize: Size(double.infinity, 50),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddTask();
            }));
          },
          elevation: 5,
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Container(
          height: deviceHeight * 0.92,
          decoration: BoxDecoration(
              color: Colors.brown[50],
              image:
                  DecorationImage(image: AssetImage('Assets/images/Logo.png'))),
          padding: EdgeInsets.symmetric(
            // horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: deviceHeight * 0.02,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ongoing Tasks'),
                    ),
                    if (FirebaseFirestore.instance.collection(user.email) !=
                        null)
                      GestureDetector(
                        onTap: () {
                          detailedView = !detailedView;
                          setState(() {
                            detailedView;
                          });
                        },
                        child: Text(
                          detailedView
                              ? 'show less details'
                              : 'show more details',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        height: constraints.maxHeight * 0.7,
                        child: Center(
                          child: Text('press the + icon to add a task'),
                        ),
                      );
                    return Expanded(child: _buildList(snapshot.data));
                  },
                  stream: FirebaseFirestore.instance
                      .collection(user.email)
                      .where('completed', isEqualTo: false)
                      .snapshots(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
