import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/expired.dart';

import 'package:todo_app/screens/login.dart';
import 'package:todo_app/providers/user_provider.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/splashscreen.dart';
import 'package:todo_app/wrapper.dart';

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
    Future<bool> onWillPop() {
      showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              content: Text('Exit App?'),
              actions: [
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);

                    return Future.value(false);
                  },
                ),
                FlatButton(
                    child: Text('Yes'),
                    color: Colors.red,
                    onPressed: () {
                      SystemNavigator.pop();
                      return Future.value(true);
                    }),
              ],
            );
          });
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: MaterialApp(
        title: 'Flutter Demo',
        // themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.grey[900],
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreenWidget(),
          '/home': (context) => Home(),
          '/completed': (context) => Completed(),
          '/login': (context) => Login(),
          '/expired': (context) => Expired(),
        },
      ),
    );
  }
}
