import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/navbar.dart';
import 'main.dart';

class Completed extends StatefulWidget {
  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  var selected = false;

  Widget _buildList(QuerySnapshot snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          return Container(
            height: 70,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Slidable(
              key: ValueKey(doc.id),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(doc['name'],
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.2,
              actions: [
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(doc.id)
                        .delete();
                    final snackBar = SnackBar(
                      content: const Text('Entry has been deleted'),
                      action: SnackBarAction(
                        label: 'undo',
                        onPressed: () {
                          FirebaseFirestore.instance.collection('tasks').add({
                            'name': doc['name'],
                            'description': doc['description'],
                            'completed': true
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
          );
        },
      ),
    );
  }

  var detailedView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.multitrack_audio),
        title: Text('Completed'),
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavBar(),
      body: Container(
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
                  .collection("tasks")
                  .where('completed', isEqualTo: true)
                  .snapshots(),
            ),
          ],
        ),
      ),
    );
  }
}
