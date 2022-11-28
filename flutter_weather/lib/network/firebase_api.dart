import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/locations.dart';
import '../data/weather_data.dart';

class FirebaseAPI {
  static final FirebaseAPI instance = FirebaseAPI._internal();
  factory FirebaseAPI() {
    return instance;
  }

  bool isLoggedIn() {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<List<WeatherData>> saveWeatherData(List<WeatherData> list) async {
    var uuid = FirebaseAuth.instance.currentUser?.uid;
    var db = FirebaseFirestore.instance;
    bool admin = false;
    return db.collection('users').doc(uuid).get().then((user) {
      admin = user.data()!['admin'];
      if (!admin) return list;
      return Future.wait(list.map((data) {
        return db.collection('history').add({
          "name": data.location.name,
          "temperature": data.temperature,
          "time": data.time.toIso8601String(),
          "weatherCode": data.weatherCode
        }).then((_) => data);
      }));
    });
  }

  Future<Map<DateTime, List<WeatherData>>> getHistory() =>
      FirebaseFirestore.instance
          .collection('history')
          .get()
          .then((value) => value.docs.map((snap) {
                String name = snap.data()["name"];
                num temperature = snap.data()["temperature"];
                DateTime time = DateTime.parse(snap.data()["time"]);
                int weatherCode = snap.data()["weatherCode"];

                Location location = locations.firstWhere((l) => l.name == name);
                return WeatherData(location, temperature, time, weatherCode);
              }))
          .then((Iterable<WeatherData> list) {
        return groupBy(list, (WeatherData w) => w.time);
      });

  FirebaseAPI._internal();
}
