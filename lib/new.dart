import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Sliding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        width: 300,
        height: 50,
        child: Text('Slide Me'),
        color: Colors.blue,
      ),
      actionPane: SlidableDrawerActionPane(),
      actions: [
        Container(
          height: 50,
          child: Text('Edit'),
          color: Colors.grey,
        ),
        Container(
          height: 50,
          child: Text('Delete'),
          color: Colors.red,
        ),
      ],
    );
  }
}
