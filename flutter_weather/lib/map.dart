import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/locations.dart';
import 'package:flutter_weather/navbutton.dart';
import 'package:flutter_weather/weather_data.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default

import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<List<WeatherData>> getData() {
    var uuid = FirebaseAuth.instance.currentUser?.uid;
    var db = FirebaseFirestore.instance;
    bool admin = false;
    DateTime time = DateTime.now();
    return db
        .collection('users')
        .doc(uuid)
        .get()
        .then((user) => admin = user.data()!['admin'])
        .then((_) => Future.wait(locations
            .map((location) => http
                    .get(Uri.parse(
                        "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&hourly=temperature_2m&current_weather=true"))
                    .then((value) {
                  var json = jsonDecode(value.body);
                  var temperature = json["current_weather"]["temperature"];
                  var weatherCode = json["current_weather"]["weathercode"];
                  weatherCode ??= 0;
                  if (admin) {
                    db.collection('history').add({
                      "name": location.name,
                      "temperature": temperature,
                      "time": time.toIso8601String(),
                      "weatherCode": weatherCode
                    });
                  }
                  return WeatherData(location, temperature, time, weatherCode);
                }))
            .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WeatherData>>(
        future: getData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<WeatherData>> snapshot) {
          Widget content;

          if (!snapshot.hasData) {
            content = Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).primaryColor, size: 100));
          } else {
            final markers = snapshot.data!
                .map(
                  (weatherData) => Marker(
                    width: 60,
                    height: 30,
                    point: LatLng(weatherData.location.latitude,
                        weatherData.location.longitude),
                    builder: (ctx) => Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text("${weatherData.temperature}°C",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                )
                .toList();
            content = FlutterMap(
              options: MapOptions(
                center: LatLng(47.079254, 19.329366),
                zoom: 7,
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(markers: markers),
              ],
            );
          }

          return Scaffold(
            body: Stack(
              children: [content],
            ),
            floatingActionButton: navButton(
                context: context, text: "See history", route: "/history"),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        });
  }
}
