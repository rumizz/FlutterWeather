import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/firebase/firebase_api.dart';

class LoginNotifier extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool _admin = false;
  bool get admin => _admin;
  String _error = '';
  String get error => _error;

  LoginNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _loggedIn = false;
        _admin = false;
        _loading = false;
        notifyListeners();
      } else {
        _loggedIn = true;
        FirebaseAPI().isAdmin().then((value) {
          _admin = value;
          _loading = false;
          notifyListeners();
        });
      }
    });
  }

  void login(String username, String password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "$username@flutterweather.com", password: password)
        .catchError((error) {
      _error = error.toString().substring(error.toString().indexOf("]") + 2);
    });
  }
}
