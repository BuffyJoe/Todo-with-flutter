import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:todo_app/screens/home.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (builder) {
        return Home();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image(
        image: AssetImage('Assets/images/Logo.png'),
        height: 100,
        width: 100,
      ),
    ));
  }
}
