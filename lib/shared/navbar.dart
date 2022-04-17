import 'package:flutter/material.dart';

import 'package:todo_app/screens/add_task.dart';

class BottomNavBar extends StatelessWidget {
  final bool home;
  BottomNavBar({this.home: false});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue,
      shape: CircularNotchedRectangle(),
      notchMargin: 5.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !home
              ? Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return AddTask();
                      }));
                    },
                    iconSize: 30,
                    icon: Icon(Icons.add_box),
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {},
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/completed', (route) => false);
                },
                iconSize: 30,
                color: Colors.white,
                icon: Icon(Icons.check_box)),
          ),
        ],
      ),
    );
  }
}
