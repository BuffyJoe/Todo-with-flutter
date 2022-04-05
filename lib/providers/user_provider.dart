import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _uservar = FirebaseAuth.instance.currentUser;

  User get user => _uservar;

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void signUp({@required String email, @required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _uservar = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _uservar = null;
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
      _uservar = null;
      notifyListeners();
    }
  }
}
