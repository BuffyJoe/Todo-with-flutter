import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AddTask extends StatelessWidget {
  var textcontrol = '';
  var descriptionControl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Container(
        height: 700,
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextFormField(
            onChanged: (value) {
              textcontrol = value;
            },
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          TextFormField(
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
            child: Text(
              'done',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
              if (textcontrol.isEmpty) {
                return;
              }
              FirebaseFirestore.instance.collection('tasks').add(
                {
                  'name': textcontrol,
                  'description': descriptionControl,
                  'completed': false,
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
