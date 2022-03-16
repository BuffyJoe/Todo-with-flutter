import 'package:flutter/material.dart';
import 'package:todo_app/completed.dart';
import 'package:todo_app/main.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
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
                    return Home();
                  }));
                },
                icon: Icon(Icons.home)),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) {
                    return Completed();
                  }));
                },
                icon: Icon(Icons.check_box)),
            title: Text('completed'),
          ),
        ],
      ),
    );
  }
}
