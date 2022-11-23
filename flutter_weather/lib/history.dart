import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weather/appbar.dart';
import 'package:flutter_weather/navbutton.dart';
import "package:collection/collection.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'locations.dart';
import 'weather_data.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<Map<String, List<WeatherData>>> getData() {
    return FirebaseFirestore.instance
        .collection('history')
        .get()
        .then((value) => value.docs.map((snap) {
              print('location ' + snap.data().toString());
              Location location =
                  locations.firstWhere((l) => l.name == snap.data()["name"]);
              print('location ' +
                  location.name.toString() +
                  ' ' +
                  location.latitude.toString() +
                  ' ' +
                  location.longitude.toString());
              return WeatherData(
                  location, snap.data()["temperature"], snap.data()["time"]);
            }))
        .then((list) => groupBy(list, (WeatherData w) => w.time));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<WeatherData>>>(
        future: getData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<WeatherData>>> historyGroups) {
          Widget content;
          if (!historyGroups.hasData || historyGroups.data!.isEmpty) {
            content = LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).primaryColor, size: 100);
          } else {
            content = Container(
                constraints: const BoxConstraints(maxWidth: 860),
                margin: const EdgeInsets.only(bottom: 90),
                padding: const EdgeInsets.all(30),
                child: ListView(
                    children: historyGroups.data!.values
                        .map<Widget>((List<WeatherData> value) =>
                            weatherHistoryGroup(
                                context: context,
                                data: value,
                                date: value[0].time.toString()))
                        .toList()));
          }
          return Scaffold(
              appBar: weatherAppBar(context: context, title: "History"),
              floatingActionButton:
                  navButton(context: context, text: "See map", route: "/map"),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: Center(child: content));
        });
  }

  Widget weatherHistoryGroup(
      {required BuildContext context,
      required String date,
      required List<WeatherData> data}) {
    var list = data
        .map((d) => weatherHistoryItem(
            context: context,
            city: d.location.name,
            temperature: "${d.temperature}°C"))
        .toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 16),
          child: Text(date,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      ...list
    ]);
  }

  Widget weatherHistoryItem(
      {required BuildContext context,
      required String city,
      required String temperature}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 5,
            blurRadius: 7,

            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            "cloud.svg",
            semanticsLabel: 'Cloudy',
            height: 40,
            width: 40,
          ),
          Text(city,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          const Spacer(),
          Text(temperature,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }
}
