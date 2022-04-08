import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _uservar = FirebaseAuth.instance.currentUser;

  User get user => _uservar;
  String error;

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void signUp(
      {@required String email,
      @required String password,
      @required String password2}) async {
    if (password != password2) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _uservar = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      error = Errors.show(e.toString());
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
      error = e.code.toString();
      print(error);

      notifyListeners();
    }
  }
}

class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "This e-mail address is already in use, please use a different e-mail address.";

      case 'ERROR_INVALID_EMAIL':
        return "The email address is badly formatted.";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "The e-mail address in your Facebook account has been registered in the system before. Please login by trying other methods with this e-mail address.";

      case 'wrong-password':
        return "E-mail address or password is incorrect.";

      default:
        return "An error has occurred";
    }
  }
}
