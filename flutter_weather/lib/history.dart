import 'package:flutter/material.dart';
import 'package:flutter_weather/appbar.dart';
import 'package:flutter_weather/navbutton.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: weatherAppBar(title: "History"),
        floatingActionButton:
            navButton(context: context, text: "See map", route: "/map"),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
            margin: const EdgeInsets.only(bottom: 120),
            child: ListView(
              children: [
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
                Text("History"),
              ],
            )));
  }
}
