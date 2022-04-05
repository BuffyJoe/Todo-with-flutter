import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/signup.dart';

import 'package:provider/provider.dart';
import 'package:todo_app/providers/user_provider.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User user = FirebaseAuth.instance.currentUser;

  var change = true;
  var showPassword = true;
  var error = false;

  var email = TextEditingController();

  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<User> CreateAccount(String email, String password) async {}

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: user != null ? Text(user.email) : Text('not logged in'),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Column(
          children: [
            Text('Don\'t have an account?'),
            GestureDetector(
              child: Text(
                'Sign-up Instead',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text('email')),
                controller: email,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text('password')),
                obscureText: showPassword,
                controller: password,
              ),
              SizedBox(
                height: 10,
              ),
              change
                  ? GestureDetector(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Provider.of<UserProvider>(context, listen: false)
                            .signIn(email: email.text, password: password.text);
                      },
                    )
                  : CircularProgressIndicator(),
              RaisedButton(
                child: Text('signout'),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();

                  setState(() {
                    user;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
