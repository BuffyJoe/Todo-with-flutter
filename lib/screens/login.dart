import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/providers/user_provider.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User user = FirebaseAuth.instance.currentUser;
  var change = true;
  var signUp = false;
  var email = TextEditingController();

  var password = TextEditingController();

  var password2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<User> CreateAccount(String email, String password) async {}

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // backgroundColor: Colors.brown[50],
        bottomNavigationBar: Container(
          height: 50,
          child: Column(
            children: [
              Text(signUp
                  ? 'Already Have an Account?'
                  : 'Don\'t have an account?'),
              GestureDetector(
                child: Text(
                  signUp ? 'Log-in instead' : 'Sign-up Instead',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  setState(() {
                    signUp = !signUp;
                  });
                },
              ),
            ],
          ),
        ),
        body: Container(
          // color: Colors.brown[50],
          height: 700,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MY TO-DO',
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontFamily: 'Monoton Regular',
                          fontSize: 50,
                          color: Colors.blue),
                    ),
                    Text(
                      signUp
                          ? 'Create an Account to get started'
                          : 'Sign in to continue',
                      style:
                          TextStyle(fontFamily: 'Chicken Hunter', fontSize: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text('email')),
                controller: email,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text('password')),
                obscureText: true,
                controller: password,
              ),
              SizedBox(
                height: signUp ? 20 : 0,
              ),
              signUp
                  ? TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('confirm password')),
                      obscureText: true,
                      controller: password2,
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              !Provider.of<UserProvider>(context, listen: true).is_loading
                  ? GestureDetector(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text(
                          signUp ? 'Create' : 'Submit',
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
                        if (email.text.isEmpty || password.text.isEmpty) return;
                        setState(() {
                          change = !change;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          if (signUp) {
                            Provider.of<UserProvider>(context, listen: false)
                                .signUp(
                                    email: email.text.replaceAll(' ', ''),
                                    password: password.text,
                                    password2: password2.text);

                            setState(() {
                              change = !change;
                            });
                          } else {
                            Provider.of<UserProvider>(context, listen: false)
                                .signIn(
                              email: email.text.replaceAll(' ', ''),
                              password: password.text,
                            );

                            setState(() {
                              change = !change;
                            });
                          }
                        });
                      },
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
