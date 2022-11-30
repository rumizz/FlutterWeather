import 'package:flutter/material.dart';

class RouteNotifier extends ChangeNotifier {
  String _route = "map";
  String get route => _route;

  void setRoute(String route) {
    _route = route;
    notifyListeners();
  }
}
