import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/screens/home.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BottomNavigationBar(
        backgroundColor: Colors.blue[400],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        unselectedFontSize: 0.0,
        selectedFontSize: 0.0,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) {
                    return AddTask();
                  }));
                },
                iconSize: 30,
                icon: Icon(Icons.add_box_rounded)),
            title: Text('Add Task'),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (builder) {
                    return Completed();
                  }), (Route<dynamic> route) => false);
                },
                iconSize: 30,
                icon: Icon(Icons.check_box)),
            title: Text('completed'),
          ),
        ],
      ),
    );
  }
}
