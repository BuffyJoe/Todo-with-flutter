import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/login.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/navbar.dart';
import 'package:todo_app/screens/edit.dart';
import 'package:todo_app/screens/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User>(
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
      ),
      routes: {
        '/home': (context) => Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/completed': (context) => Completed(),
        '/login': (context) => Login(),
      },
    );
  }
}

Widget _getLandingPage() {
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
