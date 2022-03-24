import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Edit extends StatefulWidget {
  final String task;
  final String name;
  final String description;
  final bool completed;
  final Timestamp doc;
  Edit(
      {this.task,
      this.name,
      this.description,
      this.completed,
      @required this.doc});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  var textcontrol = '';

  var descriptionControl = '';

  var lastDate = DateTime.now();
  DateTime initialDate;
  var newDateBool = false;
  DateTime newDate;

  Future pickDate(BuildContext context) async {
    initialDate = initialDate ?? widget.doc.toDate();
    newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(lastDate.year + 1),
    );
    print(newDate);

    print(newDate);
    if (newDate == null) return;
    setState(() {
      newDate;
      initialDate = newDate;
      newDateBool = true;
    });
  }

  DateTime firstDate;

  @override
  Widget build(BuildContext context) {
    firstDate = widget.doc.toDate();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextFormField(
              initialValue: widget.name,
              onChanged: (value) {
                textcontrol = value;
              },
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextFormField(
              initialValue: widget.description,
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
                  child: newDateBool
                      ? Text(
                          "${newDate.year}/${newDate.month}/${newDate.day}",
                        )
                      : Text(
                          "${firstDate.year}/${firstDate.month}/${firstDate.day}",
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
                if (newDate == null) {
                  newDate = widget.doc.toDate();
                }

                if (textcontrol.isEmpty) {
                  textcontrol = widget.name;
                }
                if (descriptionControl.isEmpty) {
                  descriptionControl = widget.description;
                }
                FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(widget.task)
                    .update(
                  {
                    'name': textcontrol,
                    'description': descriptionControl,
                    'DOC': newDate,
                  },
                );
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ),
    );
  }
}
