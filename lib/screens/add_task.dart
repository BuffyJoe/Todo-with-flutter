import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var textcontrol = '';

  var descriptionControl = '';
  var initialDate = DateTime.now();

  var lastDate = DateTime.now();
  DateTime newDate = DateTime.now();
  Future pickDate(BuildContext context) async {
    final Date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(lastDate.year + 2),
    );

    if (Date == null) return;
    newDate = Date;
    setState(() {
      newDate;
      initialDate = Date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Container(
        height: 700,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
            Row(
              children: [
                FlatButton(
                  child: Text(
                    'Date Picker',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    pickDate(context);
                  },
                  // color: Colors.brown[400],
                ),
                Container(
                  child:
                      Text("${newDate.year}/${newDate.month}/${newDate.day}"),
                  padding: EdgeInsets.all(5),
                )
              ],
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
                    'DOC': newDate,
                    "CREATED": DateTime.now()
                  },
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
