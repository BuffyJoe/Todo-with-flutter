import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/shared/navbar.dart';
import 'package:todo_app/shared/appbar.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/shared/slidable.dart';

class Completed extends StatefulWidget {
  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  var selected = false;
  User user = FirebaseAuth.instance.currentUser;
  Widget _buildList(QuerySnapshot snapshot) {
    return CompletedTaskSlidableTile(snapshot);
  }

  var detailedView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBarCustom('Completed'),
        preferredSize: Size(double.infinity, 50),
      ),
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
