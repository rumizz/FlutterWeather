import 'package:flutter/material.dart';
import 'package:flutter_weather/firebase/firebase_api.dart';
import 'package:flutter_weather/weather/weather_api.dart';

import 'weather_data.dart';
import 'dart:async';

class WeatherNotifier with ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;
  List<WeatherData> _currentWeather = [];
  List<WeatherData> get currentWeather => _currentWeather;
  Map<DateTime, List<WeatherData>> _history = {};
  Map<DateTime, List<WeatherData>> get history => _history;

  WeatherNotifier() {
    fetch();
    Timer.periodic(const Duration(minutes: 1), (Timer t) => fetch());
  }
  void fetch() {
    print("update");
    WeatherAPI.instance.getCurrentWeather().then((value) {
      _currentWeather = value;
    }).then((value) => FirebaseAPI.instance.getHistory().then((value) {
          _history = value;
          _loading = false;
          notifyListeners();
        }));
  }
}