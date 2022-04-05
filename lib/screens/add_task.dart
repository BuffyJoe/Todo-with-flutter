import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/home.dart';

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
  TimeOfDay newTime = TimeOfDay.now();
  Future pickDate(BuildContext context) async {
    final Date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(lastDate.year + 1),
    );
    var Time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (Date == null) return;
    if (Time == null) return;
    newDate = Date;
    newTime = Time;
    setState(() {
      newDate;
      initialDate = Date;
      newTime;
    });
  }

  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${DateFormat("yMMMMEEEEd").format(newDate)}'),
                        Text("Time: ${newTime.format(context)}")
                      ],
                    ),
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
                  FirebaseFirestore.instance.collection(user.email).add(
                    {
                      'name': textcontrol,
                      'description': descriptionControl,
                      'completed': false,
                      'DOC': newDate,
                      'created': DateTime.now(),
                      'time': newTime.format(context).toString(),
                    },
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
