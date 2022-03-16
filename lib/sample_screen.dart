import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class NewScreem extends StatelessWidget {
  final String task;
  final String name;
  final String description;
  final bool completed;
  NewScreem({this.task, this.name, this.description, this.completed});

  var textcontrol = '';
  var descriptionControl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Container(
        height: 700,
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextFormField(
            initialValue: name,
            onChanged: (value) {
              textcontrol = value;
            },
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          TextFormField(
            initialValue: description,
            onChanged: (value) {
              descriptionControl = value;
            },
            minLines: 3,
            maxLines: 5,
            decoration:
                InputDecoration(labelText: 'Task Description (optional)'),
          ),
          Container(
            height: 10,
          ),
          RaisedButton(
            child: Text('done'),
            onPressed: () {
              if (textcontrol.isEmpty) {
                return;
              }
              FirebaseFirestore.instance.collection('tasks').doc(task).update(
                {
                  'name': textcontrol,
                  'description': descriptionControl,
                },
              );
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }
}

class edit extends StatefulWidget {
  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [TextField()],
    );
  }
}
