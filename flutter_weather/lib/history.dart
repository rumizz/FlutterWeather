import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weather/appbar.dart';
import 'package:flutter_weather/navbutton.dart';
import "package:collection/collection.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather_icons/weather_icons.dart';

import 'locations.dart';
import 'weather_data.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<Map<String, List<WeatherData>>> getData() {
    return FirebaseFirestore.instance
        .collection('history')
        .get()
        .then((value) => value.docs.map((snap) {
              String name = snap.data()["name"];
              num temperature = snap.data()["temperature"];
              String time = snap.data()["time"];
              int weatherCode = snap.data()["weatherCode"];
              weatherCode ??= 0;

              Location location = locations.firstWhere((l) => l.name == name);
              return WeatherData(location, temperature, time, weatherCode);
            }))
        .then((Iterable<WeatherData> list) {
      return groupBy(list, (WeatherData w) => w.time);
    }).catchError((error, StackTrace stackTrace) =>
            print("Failed to get history: $error " + stackTrace.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<WeatherData>>>(
        future: getData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, List<WeatherData>>> historyGroups) {
          Widget content;

          print("history " + historyGroups.data.toString());
          if (!historyGroups.hasData) {
            content = LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).primaryColor, size: 100);
          } else if (historyGroups.data!.isEmpty) {
            content = const Text("No data");
          } else {
            content = ListView(
                padding:
                    const EdgeInsets.only(left: 30, right: 30, bottom: 120),
                children: historyGroups.data!.values
                    .map<Widget>((List<WeatherData> value) =>
                        weatherHistoryGroup(
                            context: context,
                            data: value,
                            date: value[0].time.toString()))
                    .toList());
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
            weatherCode: d.weatherCode,
            isDayTime: d.time.substring(11).compareTo("18:00") < 0 &&
                d.time.substring(11).compareTo("06:00") > 0,
            temperature: "${d.temperature}°C"))
        .toList();

    return Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 16),
          child: Text(date,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      ...list
    ]));
  }

  Widget weatherHistoryItem(
      {required BuildContext context,
      required String city,
      required int weatherCode,
      required bool isDayTime,
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
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: BoxedIcon(getWeatherIcon(weatherCode, isDayTime),
                  size: 40, color: Theme.of(context).primaryColor)),
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

  IconData getWeatherIcon(int code, isDayTime) {
    switch (code) {
      case 0:
        return isDayTime ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
      case 1:
        return isDayTime
            ? WeatherIcons.day_cloudy
            : WeatherIcons.night_partly_cloudy;
      case 2:
        return isDayTime ? WeatherIcons.day_cloudy : WeatherIcons.night_cloudy;
      case 3:
        return isDayTime
            ? WeatherIcons.day_sunny_overcast
            : WeatherIcons.night_alt_cloudy;
      case 45:
      case 48:
        return isDayTime ? WeatherIcons.day_fog : WeatherIcons.night_fog;
    }
    if (51 <= code && code <= 67) {
      return isDayTime ? WeatherIcons.day_rain : WeatherIcons.night_rain;
    }
    if ((71 <= code && code <= 77) || code == 85 || code == 86) {
      return isDayTime ? WeatherIcons.day_snow : WeatherIcons.night_snow;
    }
    if (80 <= code && code <= 82) {
      return isDayTime ? WeatherIcons.day_showers : WeatherIcons.night_showers;
    }
    if (code >= 95) {
      return isDayTime
          ? WeatherIcons.day_thunderstorm
          : WeatherIcons.night_thunderstorm;
    }

    return isDayTime ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
  }
}
