import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../weather/locations.dart';
import '../weather/weather_data.dart';

class FirebaseAPI {
  static final FirebaseAPI instance = FirebaseAPI._internal();

  DateTime _lastDate = DateTime.now();

  factory FirebaseAPI() {
    return instance;
  }

  Future<bool> isAdmin() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => value.data()?['admin'] ?? false);
  }

  Future<List<WeatherData>> saveWeatherData(List<WeatherData> list) {
    return isAdmin().then((isAdmin) {
      if (!isAdmin) return list;
      return Future.wait(list.map((data) {
        return FirebaseFirestore.instance.collection('history').add({
          "name": data.location.name,
          "temperature": data.temperature,
          "time": data.time.toIso8601String(),
          "weatherCode": data.weatherCode
        }).then((_) => data);
      }));
    });
  }

  Future<Map<DateTime, List<WeatherData>>> getHistory(int page) =>
      FirebaseFirestore.instance
          .collection('history')
          .orderBy('time', descending: true)
          .startAfter([_lastDate.toIso8601String()])
          .limit(locations.length * 2)
          .get()
          .then((value) => value.docs.map((snap) {
                String name = snap.data()["name"];
                num temperature = snap.data()["temperature"];
                DateTime time = DateTime.parse(snap.data()["time"]);
                int weatherCode = snap.data()["weatherCode"];

                Location location = locations.firstWhere((l) => l.name == name);
                _lastDate = time;
                return WeatherData(location, temperature, time, weatherCode);
              }))
          .then((data) => groupBy(data, (data) => data.time));

  FirebaseAPI._internal();
}
