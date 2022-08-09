import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/add_task.dart';

import 'package:todo_app/shared/navbar.dart';
import 'package:todo_app/shared/appbar.dart';
import 'package:todo_app/widgets/completedTaskSlidableWidget.dart';

class Completed extends StatefulWidget {
  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  var selected = false;
  User user = FirebaseAuth.instance.currentUser;
  Widget _buildList(QuerySnapshot snapshot) {
    return CompletedTaskSlidableWidget(snapshot, detailedView);
  }

  var detailedView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom('Completed'),
        preferredSize: Size(double.infinity, 60),
      ),
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.92,
          // color: Colors.red,
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Completed Tasks'),
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
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
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
                    .collection('tasks')
                    .where('id', isEqualTo: user.email)
                    .where('completed', isEqualTo: true)
                    .orderBy('DOC', descending: true)
                    .snapshots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
