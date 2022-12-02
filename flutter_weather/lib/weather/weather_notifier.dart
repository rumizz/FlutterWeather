import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/weather_api.dart';

import 'weather_data.dart';
import 'dart:async';

class WeatherNotifier with ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;
  List<WeatherData> _currentWeather = [];
  List<WeatherData> get currentWeather => _currentWeather;

  WeatherNotifier() {
    fetch();
    Timer.periodic(const Duration(minutes: 1), (Timer t) => fetch());
  }
  void fetch() {
    WeatherAPI.instance.getCurrentWeather().then((value) {
      _currentWeather = value;
      _loading = false;
      notifyListeners();
    });
  }
}
