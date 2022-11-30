import 'dart:convert';

import 'package:flutter_weather/firebase/firebase_api.dart';
import 'package:flutter_weather/weather/weather_data.dart';
import 'package:http/http.dart' as http;

import 'locations.dart';

class WeatherAPI {
  static final WeatherAPI instance = WeatherAPI._internal();
  factory WeatherAPI() {
    return instance;
  }
  Future<List<WeatherData>> getCurrentWeather() {
    DateTime time = DateTime.now();
    return Future.wait(locations
            .map((location) => http
                    .get(Uri.parse(
                        "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&hourly=temperature_2m&current_weather=true"))
                    .then((value) {
                  var json = jsonDecode(value.body);
                  var temperature = json["current_weather"]["temperature"];
                  var weatherCode = json["current_weather"]["weathercode"];
                  weatherCode ??= 0;

                  return WeatherData(location, temperature, time, weatherCode);
                }))
            .toList())
        .then((list) => FirebaseAPI.instance.saveWeatherData(list));
  }

  WeatherAPI._internal();
}
