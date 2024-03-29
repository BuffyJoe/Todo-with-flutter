import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/screens/onboarding/onboarding_screen.dart';

import 'package:todo_app/wrapper.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) {
        return Wrapper();
      }), (Route<dynamic> route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
      child: Image(
        image: AssetImage('Assets/images/Logo.png'),
        height: 100,
        width: 100,
      ),
    ));
  }
}
