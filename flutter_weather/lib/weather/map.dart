import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/component/navbutton.dart';
import 'package:flutter_weather/weather/weather_notifier.dart';
import 'package:flutter_weather/weather/weather_data.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backInterceptor, zIndex: 2, name: "map_back");
  }

  @override
  void dispose() {
    BackButtonInterceptor.removeByName("map_back");
    super.dispose();
  }

  bool backInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("Do you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text("Log Out"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) => SystemChannels
                    .platform
                    .invokeMethod('SystemNavigator.pop'));
              },
            ),
            TextButton(
              child: const Text("Exit"),
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
          ],
        );
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (context.watch<WeatherNotifier>().loading) {
      content = Center(
          child: LoadingAnimationWidget.discreteCircle(
              color: Theme.of(context).primaryColor, size: 50));
    } else {
      List<WeatherData> currentWeather =
          context.watch<WeatherNotifier>().currentWeather;
      final markers = currentWeather
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
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
      floatingActionButton:
          navButton(context: context, text: "See history", route: "history"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
