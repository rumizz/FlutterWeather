import 'package:flutter/material.dart';
import 'package:flutter_weather/component/navbutton.dart';
import 'package:flutter_weather/network/firebase_api.dart';
import 'package:flutter_weather/network/weather_api.dart';
import 'package:flutter_weather/data/weather_data.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default

import 'package:loading_animation_widget/loading_animation_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<List<WeatherData>> getData() {
    return WeatherAPI.instance
        .getCurrentWeather()
        .then(FirebaseAPI.instance.saveWeatherData);
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              ),
                            ],
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
