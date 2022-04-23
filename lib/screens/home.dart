import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/shared/navbar.dart';
import 'package:todo_app/shared/appbar.dart';
import 'package:todo_app/widgets/activeTaskSlidableWidget.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // create task function
  User user = FirebaseAuth.instance.currentUser;

  // ask before exiting the app
  DateTime today = DateTime.now();
  int backPressCounter = 1;
  int backPressTotal = 2;
  var expired = false;

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
          DateTime dateTime = DateTime.parse(doc['DOC'].toDate().toString());
          if (dateTime.year < today.year ||
              (dateTime.day < today.day &&
                  dateTime.month <= today.month &&
                  dateTime.year <= today.year)) {
            FirebaseFirestore.instance.collection('tasks').doc(doc.id).update({
              'expired': true,
            });
          } else {}
          return Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            padding: EdgeInsets.zero,
            height: detailedView ? 170 : 70,
            child: ActiveTaskSlidableWidget(doc),
          );
        },
      ),
    );
  }

  var detailedView = false;
  List items = ['sign up', 'setting', 'about us'];
  @override
  Widget build(BuildContext context) {
    // var snapshot = ;
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
          preferredSize: Size(double.infinity, 60),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          child: const Icon(
            Icons.add,
            // color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddTask();
            }));
          },
          elevation: 5,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Container(
          height: deviceHeight * 0.92,
          decoration: BoxDecoration(
              // color: Colors.brown[50],
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
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ongoing Tasks'),
                    ),
                    if (FirebaseFirestore.instance.collection('tasks') != null)
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
                      .collection('tasks')
                      .where('id', isEqualTo: user.email)
                      .where('expired', isEqualTo: false)
                      .where('completed', isEqualTo: false)
                      .orderBy('DOC', descending: true)
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
