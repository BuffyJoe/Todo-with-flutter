import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/navbar.dart';
import 'package:todo_app/screens/edit.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // create task function
  void _saveTask(TextEditingController _taskController,
      TextEditingController _description) {
    print(FirebaseFirestore.instance.collection('tasks').id);
    if (_taskController.text.isEmpty) {
      return;
    }
    final taskname = _taskController.text;
    final description = _description.text;
    FirebaseFirestore.instance.collection('tasks').add({
      'name': taskname,
      'description': description,
      'completed': false,
    });
  }

  var counter = '';
  var tasks = FirebaseFirestore.instance.collection('tasks').snapshots().length;

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
              height: detailedView ? 150 : 70,
              color: Colors.blue,
              child: Slidable(
                actionExtentRatio: 0.3,
                key: ValueKey(doc.id),
                child: ListTile(
                  title: Container(
                    margin: EdgeInsets.all(8),
                    child: Text(
                      doc['name'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  subtitle: detailedView
                      ? Container(
                          height: 100,
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
                          .collection("tasks")
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
                                .collection('tasks')
                                .doc(doc.id)
                                .update({'completed': false});
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('completed');
                    },
                    child: Container(
                      height: detailedView ? 150 : 70,
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
                            completed: doc['completed']);
                      }));
                    },
                    child: Container(
                      height: detailedView ? 150 : 70,
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
                                  child: Text('Yes'),
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
                                            'description': doc['description'],
                                            'completed': false,
                                          });
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                ),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                      height: detailedView ? 150 : 70,
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

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text('Todo'),
        centerTitle: true,
        toolbarHeight: deviceHeight * 0.08,
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
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
      ),
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
                    .collection("tasks")
                    .where('completed', isEqualTo: false)
                    .snapshots(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
