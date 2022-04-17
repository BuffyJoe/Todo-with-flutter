import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:todo_app/screens/login.dart';
import 'package:todo_app/screens/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
