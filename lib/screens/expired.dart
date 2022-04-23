import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/add_task.dart';

import 'package:todo_app/shared/navbar.dart';
import 'package:todo_app/shared/appbar.dart';
import 'package:todo_app/widgets/expiredTaskSlidableWidget.dart';

class Expired extends StatefulWidget {
  @override
  State<Expired> createState() => _ExpiredState();
}

class _ExpiredState extends State<Expired> {
  var selected = false;
  User user = FirebaseAuth.instance.currentUser;
  Widget _buildList(QuerySnapshot snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Assets/images/Logo.png'),
        ),
      ),
      child: ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          return Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red[300],
              ),
              padding: EdgeInsets.zero,
              height: detailedView ? 170 : 70,
              child: ExpiredTaskSlidableWidget(doc));
        },
      ),
    );
  }

  var detailedView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom('Expired'),
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
          // color: Colors.brown[50],
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
                    .collection('tasks')
                    .where('expired', isEqualTo: true)
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
