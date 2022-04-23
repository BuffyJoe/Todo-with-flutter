import 'package:flutter/material.dart';

import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/expired.dart';

class BottomNavBar extends StatelessWidget {
  final bool home;
  BottomNavBar({this.home: false});
  @override
  Widget build(BuildContext context) {
    final Brightness theme = Theme.of(context).brightness;
    return BottomAppBar(
      color: theme == Brightness.dark ? Colors.grey[700] : Colors.blue,
      shape: CircularNotchedRectangle(),
      notchMargin: 5.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: IconButton(
              icon: Icon(Icons.cancel),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/expired', (route) => false);
              },
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
