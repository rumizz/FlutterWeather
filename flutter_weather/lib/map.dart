import 'package:flutter/material.dart';
import 'package:flutter_weather/locations.dart';
import 'package:flutter_weather/navbutton.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final markers = locations
        .map(
          (location) => Marker(
            width: 60,
            height: 30,
            point: LatLng(location.latitude, location.longitude),
            builder: (ctx) => Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: Text("18°C",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold))),
          ),
        )
        .toList();
    return Scaffold(
      body: Stack(
        children: [
          Flexible(
            child: FlutterMap(
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
            ),
          ),
        ],
      ),
      floatingActionButton:
          navButton(context: context, text: "See history", route: "/history"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
