import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProvider with ChangeNotifier {
  User _uservar = FirebaseAuth.instance.currentUser;

  User get user => _uservar;
  String _error;
  String get error => _error;

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void signUp(
      {@required String email,
      @required String password,
      @required String password2}) async {
    if (password != password2) {
      Fluttertoast.showToast(
        msg: 'Password does not match',
        gravity: ToastGravity.TOP,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.transparent,
        fontSize: 18,
      );
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _uservar = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('in');
      print(e.code);
      Fluttertoast.showToast(
        msg: Errors.show(e.code),
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Color.fromRGBO(255, 0, 0, 0.6),
        fontSize: 15,
      );
      notifyListeners();
    }
  }

  void signIn({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _uservar = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      Fluttertoast.showToast(
        msg: Errors.show(e.code),
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Color.fromRGBO(255, 0, 0, 0.6),
        fontSize: 15,
      );
      notifyListeners();
    }
  }
}

class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "The email address is invalid, write a valid email address to continue.";

      case 'user-not-found':
        return "This email is not recorgnized, user not found";

      case 'wrong-password':
        return "E-mail address or password is incorrect.";

      case 'too-many-requests':
        return 'You have made too many attempts, try again later';
      case 'email-already-in-use':
        return 'Email already exists, try Logging in instead';
      default:
        return "An error occurred, check your internet connection";
    }
  }
}
