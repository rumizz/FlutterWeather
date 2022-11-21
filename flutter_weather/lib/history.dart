import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_weather/appbar.dart';
import 'package:flutter_weather/navbutton.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: weatherAppBar(context: context, title: "History"),
        floatingActionButton:
            navButton(context: context, text: "See map", route: "/map"),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 860),
                margin: const EdgeInsets.only(bottom: 90),
                padding: const EdgeInsets.all(30),
                child: ListView(
                  children: [
                    weatherHistoryGroup(context: context, date: "Oct 2"),
                    weatherHistoryGroup(context: context, date: "Oct 1")
                  ],
                ))));
  }
}

Widget weatherHistoryGroup(
    {required BuildContext context, required String date}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 16),
        child: Text("2022. 11. 21.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    weatherHistoryItem(
        context: context, city: "Budapest, HU", temperature: "18°C"),
    weatherHistoryItem(
        context: context, city: "Budapest, HU", temperature: "18°C")
  ]);
}

Widget weatherHistoryItem(
    {required BuildContext context,
    required String city,
    required String temperature}) {
  return Container(
    constraints: BoxConstraints(maxWidth: 800),
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
