import 'package:flutter/material.dart';
import 'package:todo_app/login.dart';

class Signup extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-up for My Todo'),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Column(
          children: [
            Text('Already have an account?'),
            GestureDetector(
              child: Text(
                'Login Instead',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (builder) {
                  return Login();
                }), (route) => false);
              },
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
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text('password')),
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
