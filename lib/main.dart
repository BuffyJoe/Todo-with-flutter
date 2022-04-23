import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/expired.dart';

import 'package:todo_app/screens/login.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/splashscreen.dart';

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
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenWidget(),
      routes: {
        '/home': (context) => Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/completed': (context) => Completed(),
        '/login': (context) => Login(),
        '/expired': (context) => Expired(),
      },
    );
  }
}
