import 'package:flutter/material.dart';
import 'package:flutter_weather/component/appbar.dart';
import 'package:flutter_weather/component/navbutton.dart';
import "package:collection/collection.dart";
import 'package:flutter_weather/firebase/firebase_api.dart';
import 'package:flutter_weather/login/login_notifier.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

import 'weather_data.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final normalFormat = DateFormat('MMM dd');
  final adminFormat = DateFormat('dd MMM yyyy HH:mm');
  static const _pageSize = 2;
  final PagingController<int, List<WeatherData>> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          (await FirebaseAPI.instance.getHistory(pageKey)).values.toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: weatherAppBar(context: context, title: "History"),
        floatingActionButton:
            navButton(context: context, text: "See map", route: "map"),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Center(
            child: PagedListView<int, List<WeatherData>>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<List<WeatherData>>(
                    itemBuilder: (context, data, index) => weatherHistoryGroup(
                          context: context,
                          time: data[0].time,
                          data: data,
                        )))));
  }

  Widget weatherHistoryGroup(
      {required BuildContext context,
      required DateTime time,
      required List<WeatherData> data}) {
    var list = data
        .sortedBy((element) => element.location.name)
        .map((d) => weatherHistoryItem(
            context: context,
            city: d.location.name,
            weatherCode: d.weatherCode,
            isDayTime: d.time.hour >= 6 && d.time.hour < 18,
            temperature: d.temperature))
        .toList();

    return Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
        child: Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                  (context.read<LoginNotifier>().admin
                          ? adminFormat
                          : normalFormat)
                      .format(time),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))),
          ...list
        ])));
  }

  Widget weatherHistoryItem(
      {required BuildContext context,
      required String city,
      required int weatherCode,
      required bool isDayTime,
      required num temperature}) {
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
            offset: const Offset(0, 4),
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
          Text("$temperature°C",
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
      case 2:
      case 3:
        return isDayTime ? WeatherIcons.day_cloudy : WeatherIcons.night_cloudy;
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
